# Linux CMD Project: Phân tích dữ liệu phim TMDB bằng lệnh Linux

Project này dùng các lệnh Linux cơ bản (`head`, `tail`, `cut`, `sort`, `uniq`, `tr`, `awk`, `wc`) để phân tích file `tmdb-movies.csv` gồm **10.866 bộ phim** với **21 cột** (tên phim, ngân sách, doanh thu, đạo diễn, diễn viên, thể loại, ngày phát hành, điểm đánh giá...).

## 1. Cấu trúc thư mục

| File / thư mục | Nội dung |
|---|---|
| `tmdb-movies.csv` | Dữ liệu gốc |
| `clean_data.py` | Script Python nhỏ để làm sạch dữ liệu (CSV sang TSV) |
| `clean_data.tsv` | Dữ liệu sau khi làm sạch, dùng cho mọi bước phân tích |
| `cmd.sh` | Các lệnh Linux đã chọn lọc từ lịch sử làm bài, theo đúng thứ tự, có giải thích từng đoạn |
| `out/` | Kết quả của từng yêu cầu |

## 2. Cách chạy lại

Đặt `tmdb-movies.csv`, `clean_data.py` và `cmd.sh` cùng một thư mục, rồi chạy:

```bash
bash cmd.sh
```

Cần có `python3` (cho bước làm sạch) và các lệnh Linux thông thường.

## 3. Bước 0: Làm sạch dữ liệu

**Vấn đề.** Không thể dùng ngay file CSV với `awk`, `cut`, `sort`, vì:

- Có ô văn bản chứa **dấu phẩy** (ví dụ phần mô tả phim), nên nếu tách cột bằng dấu phẩy thì số cột mỗi dòng bị lệch (có dòng 10 cột, có dòng 14 cột...).
- Có ô chứa **ký tự xuống dòng**, nên file có 10.879 dòng trong khi chỉ có 10.866 phim + 1 dòng tiêu đề.

**Cách xử lý.** `clean_data.py` đọc CSV đúng chuẩn (hiểu dấu ngoặc kép), bỏ ký tự xuống dòng và tab trong ô, rồi ghi ra `clean_data.tsv`, trong đó các cột được phân tách bằng **Tab**. Bước này là bước duy nhất dùng Python; toàn bộ phân tích đều dùng lệnh Linux.

**Kiểm tra sau khi làm sạch:**

- `wc -l clean_data.tsv` ra 10.867 dòng (1 tiêu đề + 10.866 phim).
- Mọi dòng đều có đúng 21 cột.

Các cột được dùng trong bài: 4 `budget`, 5 `revenue`, 6 `original_title`, 7 `cast`, 9 `director`, 14 `genres`, 16 `release_date`, 18 `vote_average`, 19 `release_year`.

## 4. Kết quả từng yêu cầu

### Yêu cầu 1: Sắp xếp phim theo ngày phát hành giảm dần

- **Ý tưởng:** cột `release_date` có dạng `tháng/ngày/năm 2 số` (ví dụ `12/31/15`) nên không sort trực tiếp được. Cách làm: ghép một "khóa" dạng `yyyymmdd` (lấy năm đầy đủ từ cột `release_year`), sort theo khóa rồi bỏ khóa đi.
- **Kết quả:** `out/1_sorted_by_release_date_desc.tsv`. Phim mới nhất là *Martyrs* (31/12/2015).
- **Lưu ý:** các phim cùng ngày phát hành có thể đứng khác thứ tự giữa các máy (tùy cài đặt ngôn ngữ), nhưng thứ tự theo ngày luôn đúng.

### Yêu cầu 2: Phim có vote_average > 7.5

- **Ý tưởng:** lọc cột 18 bằng `awk '$18>7.5'`. Dùng `LC_ALL=C` để máy hiểu `7.5` đúng là số thập phân. Nếu thiếu, máy đặt dấu phẩy thập phân sẽ hiểu thành 7 và cho ra 1.282 phim (sai).
- **Kết quả:** `out/2_vote_gt_7.5.tsv` có **350 phim**. Dùng `>` chứ không phải `>=`, nên các phim đúng 7.5 bị loại.

### Yêu cầu 3: Doanh thu cao nhất và thấp nhất

- **Cao nhất:** *Avatar*, 2.781.505.847 USD.
- **Thấp nhất:** có **6.016 phim có doanh thu = 0**. Đây là dữ liệu bị thiếu, không phải doanh thu thật bằng 0, nên khi tìm "thấp nhất" mình bỏ các phim này. Kết quả: 2 USD (*Shattered Glass* và *Mallrats*).
- **Kết quả:** `out/3_revenue.txt`.

### Yêu cầu 4: Tổng doanh thu

- **Kết quả:** **432.720.192.875 USD** (khoảng 432,7 tỷ USD), lưu ở `out/4_total_revenue.txt`.
- **Lưu ý:** dùng `printf "%.0f"` để số in đầy đủ chứ không bị đổi sang dạng khoa học.

### Yêu cầu 5: Top 10 phim lợi nhuận cao nhất

- **Ý tưởng:** lợi nhuận = doanh thu (cột 5) trừ ngân sách (cột 4), tính cho từng phim rồi sắp xếp giảm dần và lấy 10 phim đầu.
- **Kết quả:** `out/5_top10_profit.txt`. Đứng đầu là *Avatar* (2.544.505.847 USD), rồi *Star Wars: The Force Awakens* và *Titanic*.

### Yêu cầu 6: Đạo diễn và diễn viên xuất hiện nhiều nhất

- **Ý tưởng:** một ô có thể chứa nhiều tên, ngăn cách bằng dấu `|`. Vì vậy phải tách mỗi tên ra một dòng (`tr '|' '\n'`) rồi mới đếm (`sort | uniq -c | sort -nr`).
- **Kết quả:** đạo diễn nhiều phim nhất là **Woody Allen (46 phim)**; diễn viên nhiều phim nhất là **Robert De Niro (72 phim)**. Lưu ở `out/6_director_actor.txt`.

### Yêu cầu 7: Số phim theo thể loại

- **Ý tưởng:** làm giống yêu cầu 6, với cột `genres`. Một phim có nhiều thể loại nên tổng các thể loại lớn hơn tổng số phim.
- **Kết quả:** `out/7_genres.txt`. Nhiều nhất là Drama (4.761), Comedy (3.793), Thriller (2.908), Action (2.385), Romance (1.712).

## 5. Chất lượng dữ liệu và những điều cần lưu ý

Sau khi hoàn thành các yêu cầu, mình kiểm tra lại chất lượng dữ liệu và ghi nhận:

- **Có 1 dòng bị trùng.** Phim *TEKKEN* (2010, `id = 42194`) xuất hiện 2 lần với nội dung giống hệt, nên thực tế có 10.865 phim khác nhau chứ không phải 10.866. Dòng trùng này làm file sắp xếp (yêu cầu 1) có thêm 1 dòng, tổng doanh thu (yêu cầu 4) dư 967.000 USD và số phim của các thể loại Crime, Drama, Action, Thriller, Science Fiction (yêu cầu 7) dư 1 mỗi thể loại. Các yêu cầu 2, 3, 5, 6 không bị ảnh hưởng. **Quyết định:** mình giữ nguyên dòng trùng và không chạy lại, vì ảnh hưởng rất nhỏ (967.000 USD trên tổng 432,7 tỷ USD, khoảng 0,0002%) và không làm thay đổi bất kỳ kết luận nào ở trên. Vì vậy kết quả trong `out/` **chưa loại dòng trùng này**.
- **Nhiều giá trị 0 là dữ liệu thiếu.** 5.696 phim có `budget = 0` và 6.016 phim có `revenue = 0`. Khi tính lợi nhuận (yêu cầu 5), các phim này chưa được loại; tuy vậy top 10 không bị ảnh hưởng vì top 10 đều có đủ dữ liệu.
- **Có dữ liệu đáng ngờ.** Phim *The Net* (1995) có lợi nhuận hơn 1 tỷ USD, rất bất thường, nhiều khả năng là lỗi trong dữ liệu gốc.
- **Hai phim có thể trùng tên nhưng khác nhau.** Ví dụ *Emma* (1996) và *Joan of Arc* (1999) xuất hiện 2 lần nhưng có `id` và đạo diễn khác nhau, nên đây là các phim khác nhau, không phải trùng lặp.
