#!/usr/bin/env bash
# ---------------------------------------------------------------------
# CHUẨN BỊ VÀ KIỂM TRA DỮ LIỆU
# ---------------------------------------------------------------------

# Vào thư mục làm việc
cd ~/Documents/Project1

# Tải file dữ liệu về (chỉ cần tải 1 lần)
curl -O https://raw.githubusercontent.com/yinghaoz1/tmdb-movie-dataset-analysis/master/tmdb-movies.csv

# Xem tên các cột: tách dòng đầu theo dấu phẩy, mỗi tên cột một dòng, đánh số thứ tự
# -> biết cột nào là số mấy (ví dụ 5 = revenue, 16 = release_date, 19 = release_year)
head -n 1 tmdb-movies.csv | tr ',' '\n' | nl -ba

# Đếm số cột của từng dòng khi tách theo dấu phẩy.
# Kết quả KHÔNG đồng nhất (có dòng 10, 11, 12... cột) -> tách bằng dấu phẩy là sai,
# vì có dấu phẩy nằm bên trong ô văn bản (ví dụ phần mô tả phim).
awk -F, '{print NF}' tmdb-movies.csv | sort | uniq -c

# Đếm tổng số dòng của file
wc -l tmdb-movies.csv

# Đếm số dòng bắt đầu bằng chữ số (mỗi phim thật bắt đầu bằng id là một số)
grep -c '^[0-9]' tmdb-movies.csv

# In ra những dòng KHÔNG bắt đầu bằng chữ số (dòng tiêu đề + các dòng bị ngắt xuống dòng giữa ô)
# -> tổng số dòng nhiều hơn số phim, vì có ô chứa ký tự xuống dòng
grep -n -v '^[0-9]' tmdb-movies.csv


# ---------------------------------------------------------------------
# LÀM SẠCH: ĐỔI CSV SANG TSV (phân tách bằng Tab)
# ---------------------------------------------------------------------

# Chạy script Python nhỏ (clean_data.py). Script chỉ làm 1 việc:
# đọc CSV đúng cách (hiểu dấu ngoặc kép), bỏ ký tự xuống dòng/tab trong ô,
# rồi ghi ra file clean_data.tsv phân tách bằng Tab.
# Mọi bước phân tích bên dưới đều dùng lệnh Linux.
python3 clean_data.py

# Kiểm tra: 10867 dòng = 1 dòng tiêu đề + 10866 phim
wc -l clean_data.tsv

# Kiểm tra: mọi dòng đều có đúng 21 cột (cột 21 xuất hiện 10867 lần)
awk -F'\t' '{print NF}' clean_data.tsv | sort | uniq -c

# Tạo thư mục out để lưu kết quả
mkdir -p out


# ---------------------------------------------------------------------
# YÊU CẦU 1. SẮP XẾP PHIM THEO NGÀY PHÁT HÀNH GIẢM DẦN
# ---------------------------------------------------------------------

# Ghi dòng tiêu đề vào file kết quả trước (dấu > tạo file mới)
head -1 clean_data.tsv > out/1_sorted_by_release_date_desc.tsv

# Xem thử cột 16 (release_date, dạng tháng/ngày/năm 2 số) và cột 19 (release_year)
# Vì năm trong cột 16 chỉ có 2 chữ số (60 là 1960 hay 2060?) nên lấy năm đầy đủ từ cột 19.
tail -n +2 clean_data.tsv | head -n 3 | awk -F'\t' '{print $16, "|", $19}'

# Thử tạo "khóa sắp xếp" dạng yyyymmdd cho 3 phim đầu
# split($16,d,"/") tách ngày phát hành thành d[1]=tháng, d[2]=ngày
# %04d%02d%02d ghép thành năm(4 số) tháng(2 số) ngày(2 số), ví dụ 20151231
tail -n +2 clean_data.tsv | head -n 3 | awk -F'\t' '{split($16,d,"/"); printf "%04d%02d%02d\n", $19,d[1],d[2]}'

# Lệnh chính: bỏ dòng tiêu đề -> gắn khóa yyyymmdd vào đầu mỗi dòng
# -> sort theo khóa (n = so sánh số, r = giảm dần) -> cut -f2- bỏ khóa đi
# -> >> nối kết quả vào sau dòng tiêu đề đã ghi ở trên
tail -n +2 clean_data.tsv | awk -F'\t' '{split($16,d,"/"); printf "%04d%02d%02d\t%s\n",$19,d[1],d[2],$0}' | sort -t$'\t' -k1,1nr | cut -f2- >> out/1_sorted_by_release_date_desc.tsv

# Kiểm tra: xem tên phim (cột 6) và ngày phát hành (cột 16) của 2 dòng đầu
head -2 out/1_sorted_by_release_date_desc.tsv | cut -f6,16


# ---------------------------------------------------------------------
# YÊU CẦU 2. LỌC PHIM CÓ vote_average > 7.5
# ---------------------------------------------------------------------

# Cột 18 là vote_average.
# LC_ALL=C: ép awk hiểu "7.5" là số có dấu chấm. Nếu không có, máy dùng dấu phẩy thập phân
# sẽ hiểu 7.5 là 7 và cho ra 1282 phim (sai) thay vì 350 phim (đúng).
tail -n +2 clean_data.tsv | LC_ALL=C awk -F'\t' '$18>7.5' | wc -l

# Ghi dòng tiêu đề, rồi nối các phim thỏa điều kiện vào file kết quả
head -1 clean_data.tsv > out/2_vote_gt_7.5.tsv
tail -n +2 clean_data.tsv | LC_ALL=C awk -F'\t' '$18>7.5' >> out/2_vote_gt_7.5.tsv

# Kiểm tra: 351 dòng = 1 dòng tiêu đề + 350 phim
wc -l out/2_vote_gt_7.5.tsv


# ---------------------------------------------------------------------
# YÊU CẦU 3. PHIM CÓ DOANH THU CAO NHẤT VÀ THẤP NHẤT
# ---------------------------------------------------------------------

# Cột 5 là revenue, cột 6 là original_title.
# Thử xem 3 phim đầu để chắc đang đọc đúng cột
tail -n +2 clean_data.tsv | head -3 | cut -f5,6

# Doanh thu thấp nhất khi sắp xếp tăng dần: toàn số 0 -> dữ liệu thiếu, không phải doanh thu thật
tail -n +2 clean_data.tsv | sort -t$'\t' -k5,5n | head -3 | cut -f5,6

# Đếm số phim có doanh thu = 0 (6016 phim)
tail -n +2 clean_data.tsv | awk -F'\t' '$5==0' | wc -l

# Thấp nhất khi bỏ các phim doanh thu = 0
tail -n +2 clean_data.tsv | awk -F'\t' '$5>0' | sort -t$'\t' -k5,5n | head -5 | cut -f5,6

# Ghi kết quả vào out/3_revenue.txt
echo "Doanh thu cao nhất:" > out/3_revenue.txt
tail -n +2 clean_data.tsv | sort -t$'\t' -k5,5nr | head -1 | cut -f6,5 >> out/3_revenue.txt
echo "" >> out/3_revenue.txt
echo "Số phim không có dữ liệu doanh thu:" >> out/3_revenue.txt
tail -n+2 clean_data.tsv | awk -F'\t' '$5==0' | wc -l >> out/3_revenue.txt
echo "" >> out/3_revenue.txt
echo "Doanh thu thấp nhất sau khi bỏ những những phim thiếu giá trị dữ liệu:" >> out/3_revenue.txt
tail -n +2 clean_data.tsv | awk -F'\t' '$5>0' | sort -t$'\t' -k5,5n | head -2 | cut -f6,5 >> out/3_revenue.txt

# Xem lại file kết quả
cat out/3_revenue.txt


# ---------------------------------------------------------------------
# YÊU CẦU 4. TỔNG DOANH THU CỦA TẤT CẢ CÁC PHIM
# ---------------------------------------------------------------------

# Thử cộng doanh thu của 3 phim đầu để hiểu cách awk cộng dồn:
# s=s+$5 nghĩa là "cộng doanh thu của dòng này vào biến s"
tail -n +2 clean_data.tsv | head -3 | awk -F'\t' '{s=s+$5; print$5 ,s}'

# Lệnh chính: cộng hết, END{...} chạy sau khi đã đọc hết các dòng.
# printf "%.0f" in số nguyên đầy đủ (print thường sẽ in dạng khoa học, ví dụ 4.3272e+11)
tail -n +2 clean_data.tsv | awk -F'\t' '{s=s+$5} END{printf "%.0f\n", s}'

# Ghi kết quả vào out/4_total_revenue.txt
echo "Tổng doanh thu của các bộ phim là:" > out/4_total_revenue.txt
tail -n +2 clean_data.tsv | awk -F'\t' '{s=s+$5} END{printf "%.0f\n", s}' >> out/4_total_revenue.txt
cat out/4_total_revenue.txt


# ---------------------------------------------------------------------
# YÊU CẦU 5. TOP 10 PHIM CÓ LỢI NHUẬN CAO NHẤT
# ---------------------------------------------------------------------

# Lợi nhuận = doanh thu (cột 5) - ngân sách (cột 4).
# Xem 3 phim đầu: ngân sách, doanh thu, tên phim
tail -n +2 clean_data.tsv | head -3 | cut -f4,5,6

# Tính lợi nhuận và in ra: cột đầu là lợi nhuận, cột sau là tên phim
tail -n +2 clean_data.tsv | head -3 | awk -F'\t' '{printf "%.0f\t%s\n", $5-$4, $6}'

# Tính cho tất cả phim, sắp xếp theo lợi nhuận (cột 1) giảm dần, lấy 10 phim đầu
tail -n +2 clean_data.tsv | awk -F'\t' '{printf "%.0f\t%s\n", $5-$4, $6}' | sort -t$'\t' -k1,1nr | head -10

# Ghi kết quả vào out/5_top10_profit.txt
echo "Top 10 phim có lợi nhuận cao nhất:" > out/5_top10_profit.txt
tail -n +2 clean_data.tsv | awk -F'\t' '{printf "%.0f\t%s\n", $5-$4, $6}' | sort -t$'\t' -k1,1nr | head -10 >> out/5_top10_profit.txt
cat out/5_top10_profit.txt


# ---------------------------------------------------------------------
# YÊU CẦU 6. ĐẠO DIỄN VÀ DIỄN VIÊN XUẤT HIỆN NHIỀU PHIM NHẤT
# ---------------------------------------------------------------------

# Cột 9 là director, cột 7 là cast. Một ô có thể chứa nhiều tên, ngăn cách bởi dấu |
tail -n +2 clean_data.tsv | head -3 | cut -f9
tail -n +2 clean_data.tsv | head -3 | cut -f7

# Quy trình đếm (dùng cho cả đạo diễn, diễn viên, thể loại):
#   cut -f9        lấy cột cần đếm
#   tr '|' '\n'    tách mỗi tên ra một dòng riêng
#   awk 'NF'       bỏ các dòng rỗng
#   sort           xếp để các tên giống nhau nằm cạnh nhau
#   uniq -c        đếm số lần xuất hiện của mỗi tên
#   sort -nr       sắp xếp số lần giảm dần
#   head -5        lấy 5 tên đầu
tail -n +2 clean_data.tsv | cut -f9 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr | head -5
tail -n +2 clean_data.tsv | cut -f7 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr | head -5

# Ghi kết quả (chỉ lấy người đứng đầu: head -1) vào out/6_director_actor.txt
echo "Đạo diễn có nhiều phim nhất:" > out/6_director_actor.txt
tail -n +2 clean_data.tsv | cut -f9 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr | head -1 >> out/6_director_actor.txt
echo "" >> out/6_director_actor.txt
echo "Diễn viên đóng nhiều phim nhất:" >> out/6_director_actor.txt
tail -n +2 clean_data.tsv | cut -f7 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr | head -1 >> out/6_director_actor.txt
cat out/6_director_actor.txt


# ---------------------------------------------------------------------
# YÊU CẦU 7. SỐ LƯỢNG PHIM THEO TỪNG THỂ LOẠI
# ---------------------------------------------------------------------

# Cột 14 là genres. Một phim có nhiều thể loại (ví dụ Action|Drama) nên cũng tách bằng
# tr '|' '\n' rồi đếm giống yêu cầu 6. Vì vậy tổng các thể loại lớn hơn tổng số phim.
tail -n +2 clean_data.tsv | cut -f14 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr

# Ghi kết quả vào out/7_genres.txt
echo "Số lượng phim sắp xếp theo thể loại:" > out/7_genres.txt
tail -n +2 clean_data.tsv | cut -f14 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr >> out/7_genres.txt
cat out/7_genres.txt
