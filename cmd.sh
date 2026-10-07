cd Documents/Project1
curl -O [200~https://raw.githubusercontent.com/yinghaoz1/tmdb-movie-dataset-analysis/master/tmdb-movies.csv~
curl -O https://raw.githubusercontent.com/yinghaoz1/tmdb-movie-dataset-analysis/master/tmdb-movies.csv
head -n 5 tmdb-movies.csv
head -n 1 tmdb-movies.csv
head -n 5 tmdb-movies.csv | tr ',' '/n' | wc -l
head -n 1 tmdb-movies.csv | tr ',' '/n' | wc -l
head -n 1 tmdb-movies.csv | tr ',' '/n'
head -n 1 tmdb-movies.csv | tr ',' '\n' | wc -l
ls | head -n 1 tmdb-movies.csv | tr ',' '\n' | wc -l
head -n 1 tmndb-movies.csv | tr ',' '\n' | grep -n -x release_year
head -n 1 tmdb-movies.csv | tr ',' '\n' | grep -n -x release_year
cut -d',' -f19 tmdb-movies.csv | head -n 10
head -n 1 tmdb-movies.csv | tr ',' '\n' | grep -n -x release_date
cut -d ',' -f 16 tmdb-movies.csv | head -n 10
awk -F, '{print NF}' tmdb-movies.csv | sort | uniq -c
man sort
awk -F, '{print NF}' tmdb-movies.csv | sort | uniq -c
awk -F, '{print NF}' tmdb-movies.csv | sort -b | uniq -c
man awk
tail -n +2 tmdb-movies.csv | sort -t',' -k19,19nr | head -n 5 | cut -c1-80
ẽit
exit
pwd
cd Documents/Project1
pwd
ls
head -n 1 tmdb-movies.csv
pưd
pwd
cd Documents/Project1
pwd 
ls
head -n 2 tmdb-movies.csv | tr ',' '\n' | nl -ba 
head -n 1 tmdb-movies.csv | tr ',' '\n' | nl -ba
head -n 2 tmdb-movies.csv
head -n 20 tmdb-movies.csv | cut -c1-40
grep -c ';' tmdb-movies.csv
grep -c '~' tmdb-movies.csv
awk '{print $0}' tmdb-movies.csv
awk '{print$0}' tmdb-movies.csv | head -n 2
echo "a,b" | awk '{for(i=1;i<=length($0);i++) print substr($0,i,1)}'
nano commands.sh
pwd
cd Documents/Project1 
pwd
bash commands.sh
bash commands.sh 
ls
echo "a,b" | awk '{for(i=1;i<=length($0);i++) print substr($0,i,1)}'
echo "a,b,c" | awk '{for(i=1;i<=length($0);i++){c=substr($0,i,1); if(c==",") c="~"; print "%s", c}; print ""}'
echo "a,b,c" | awk '{for(i=1;i<=length($0);i++){c=substr($0,i,1); if(c==",") c="~"; printf "%s", c}; print ""}'
rm -i commands.sh
ls
pwd 
cd Documents/Project1
pwd 
ls
head -n 2 tmdb-movies.csv
awk -F {'print NF'} tmdb-movies.csv | sort | uniq -c 
awk -F, '{print NF}' tmdb-movies.csv | sort | uniq -c
echo "a, , c" | awk -F, '{print NF}'
wc -l tmdb-movies.csv
grep -c '^[0-9]' tmdb-movies.csv
grep -n -v '^[0-9]' tmdb-movies.csv
head -n 10 tmdb-movies.csv
exit
pwd 
cd Documents/ Project1 
cd Documents/Project1
pwd
nano clean.awk
ls
nano clean.awk
rm -r clean.awk
ls
nano clean_data.py
python3 clean_data.py
ls
wc -l clean.tsv
wc -l clean_data.tsv
awk -F'\t' '{print NF}' clean_data.tsv | sort| uniq -c
mkdir -p out
ls
head -n 2 clean-data.tsv
head -n 2 clean_data.tsv
head -1 clean_data.tsv > out/1_sorted_by_release_date_desc.tsv
ls
ls al
pwd
cd out
ls
cd Documents/Project1
cd -
pwd
tail -n +2 clean_data.tsv | head -n 3 | awk -F'\t' '{print $16, "|", $19}'
tail -n +2 clean_data.tsv | head -n 3| awk -F't\' '{split($16,d,"/"); printf "%04d%02d%02d\n", $19,d[1],d[2]}'
tail -n +2 clean_data.tsv | head -n 3| awk -F'\t' '{split($16,d,"/"); printf "%04d%02d%02d\n", $19,d[1],d[2]}'
tail -n +2 clean.tsv | awk -F'\t' '{split($16,d,"/"); printf "%04d%02d%02d\t%s\n",$19,d[1],d[2],$0}' | sort -t$'\t' -k1,1nr | head -3 | cut -f1,7
tail -n +2 clean_data.tsv | awk -F'\t' '{split($16,d,"/"); printf "%04d%02d%02d\t%s\n",$19,d[1],d[2],$0}' | sort -t$'\t' -k1,1nr | head -3 | cut -f1,7 
... | sort -t$'\t' -k1,1nr | cut -f2- | head -3 | cut -f6,16
tail -n +2 clean_data.tsv | awk -F'\t' '{split($16,d,"/"); printf "%04d%02d%02d\t%s\n",$19,d[1],d[2],$0}' | sort -t$'\t' -k1,1nr | cut -f2- |head -3 | cut -f6,16
tail -n +2 clean_data.tsv | awk -F'\t' '{split($16,d,"/"); printf "%04d%02d%02d\t%s\n",$19,d[1],d[2],$0}' | sort -t$'\t' -k1,1nr | cut -f2- >> out/1_sorted_by_release_date_desc.tsv 
ls al
ls
ls out
cd out
cd 1_sorted_by_release_date_desc.tsv
head -10 1_sorted_by_release_date_desc.tsv
head -2 [200~1_sorted_by_release_date_desc.tsv
~head -2 1_sorted_by_release_date_desc.tsv
head -2 1_sorted_by_release_date_desc.tsv
tail -n +2 clean_data.tsv | head -3 | cut -f6,18
tail -n +2 clean_data.tsv | awk -F'\t' '$18>7.5' | wc -l
[200~tail -n +2 clean_data.tsv | awk -F'\t' '$18>7.5' | wc -l
tail -n +2 clean_data.tsv | awk -F'\t' '$18>7.5' | wc -l
tail -n +2 clean_data.tsv | awk -F'\t' '$18>7.5' | wc -l | head -n 10
tail -n +2 clean_data.tsv | awk -F'\t' '$18>7.5' | head -3 | cut -f6,18
tail -n +2 clean_data.tsv | LC_ALL=C awk -F'\t' '$18>7.5' | wc -l
head -1 clean_data.tsv > out/2_vote_gt_7.5.tsv
ls
ls out
tail -n +2 clean_data.tsv | LC_ALL=C awk -F'\t' '$18>7.5' >> out/2_vote_gt_7.5.tsv
wc -l out/2_vote_gt_7.5.tsv
tail -n +2 clean_data.tsv | head -3 | cut -f5,6
tail -n +2 clean_data.tsv | sort -t$'\t' -k5,5nr | head -1 | cut -f5,6
tail -n +2 clean_data.tsv | sort -t$'\t' -k5,5n | head -3 | cut -f5,6
tail -n +2 clean_data.tsv | awk -F'\t' '$5==0' | wc -l
tail -n +2 clean_data.tsv | awk -F'\t' '$5>0' | sort -t$'\t' -k5,5n | head -5 | cut -f5,6
echo "Doanh thu cao nhất:" > out/3_revenue.txt
tail -n +2 clean_data.tsv | sort -t$'\t' k5,5nr | head -1 | cut -f6,5 >> out/3_revenue.txt
tail -n +2 clean_data.tsv | sort -t$'\t' -k5,5nr | head -1 | cut -f6,5 >> out/3_revenue.txt
echo "" 
echo "" >> out/3_revenue.txt
echo "Số phim không có dữ liệu doanh thu:" >> out/3_revenue.txt
tail -n+2 clean_data.tsv | awk -F'\t' '$5==0' | wc -l >> out/3_revenue.txt
echo "" >> out/3_revenue.txt
echo "Doanh thu thấp nhất sau khi bỏ những những phim thiếu giá trị dữ liệu:" >> out/3_revenue.txt
tail -n +2 clean_data.tsv | awk -F'/t' '$5>0' | sort -t$'\t' -k5,5n | head -2 | cut -f6,5 >> out/3_revenue.txt
cat out/3_revenue.txt
tail -n +2 clean_data.tsv | awk -F'\t' '$5>0' | sort -t$'\t' -k5,5n | head -2 | cut -f6,5 >> out/3_revenue.txt
cat out/3_revenue.txt
ls out
tail -n +2 clean_data.tsv | head -3 | awk -F'\t' '{s=s+$5; print$5 ,s}'
tail -n +2 clean_data.tsv | head -3 | awk -F'\t' '{s=s+$5} END{print s}'
tail -+2 clean_data.tsv | awk -F'\t' 's=s+$5}' END{printf "%.0f\n", s}'
tail -n +2 clean_data.tsv | awk -F'\t' '{s=s+$5} END{printf "%.0f\n", s}'
echo "Tổng doanh thu của các bộ phim là:" > out/4_total_revenue.txt
tail -n +2 clean_data.tsv | awk -F'\t' '{s=s+$5} END{printf "%.0f\n", s}' >> out/4_total_revenue.txt
cat out/4_total_revenue.txt
tail -n +2 clean_data.tsv | sort -t$'\t' k5,5nr | head -10 | cut -f6,5
tail -n +2 clean_data.tsv | sort -t$'\t' -k5,5nr | head -10 | cut -f6,5
echo "Top 10 bộ phim đem về lợi nhuận cao nhất:" > out/5_top10_revenue.txt
tail -n+2 clean_data.tsv | sort -t$'\t' -k5,5nr | head -10 | cut -f6,5 >> out/5_top10_revenue.txt
cat out/5_top10_revenue.txt
rm out/5_top10_revenue.txt
ls out 
head n -1 clean_data.tsv 
head 1 clean_data.tsv
head -n 1 clean_data.tsv 
tail -n +2 clean_data.tsv | head -3 | cut -f4,5,6
tail -n +2 clean_data.tsv | head -3 | awk -F'\t' '{printf "%.0f\t%s\n", $5-%4, $6}'
tail -n +2 clean_data.tsv | head -3 | awk -F'\t' '{printf "%.0f\t%s\n", $5-$4, $6}'
tail -n +2 clean_data.tsv | awk -F'\t' '{printf "%.0f\t%s\n", $5-$4, $6}' | sort -t$'\t' -k1,1nr | head -3
tail -n +2 clean_data.tsv | awk -F'\t' '{printf "%.0f\t%s\n", $5-$4, $6}' | sort -t$'\t' -k1,1nr | head -10
echo "Top 10 phim có doanh thu cao nhất:" > out/5_top10_profit 
ls out 
cat 5_top10_profit
cat out/5_top10_profit
mv out/5_top10_profit out/5_top10_profit.txt
ls out 
cat out/5_top10_profit.txt
tail -n +2 clean_data.tsv | awk -F'\t' '{printf "%.0f\t%s\n", $5-$4, $6}' | sort -t$'\t' -k1,1nr | head -10 >> out/5_top10_profit.txt
cat out/5_top10_profit.txt
head -1 clean_data.tsv
tail -n +2 clean_data.tsv | head -3 | cut -f9
tail -n +2 clean_data.tsv | head -3 | cut -f7
tail -n +2 clean_data.tsv | cut -f9 | tr '|' '\n' | awk 'NF' | head -5
tail -n +2 clean_data.tsv | cut -f9 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr | head -5
tail -n +2 clean_data.tsv | cut -f7 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr | head -5
echo "Đạo diễn có nhiều phim nhất:" > out/^_director_actor.txt
ls out 
mv out/^_director_actor.txt out/6_director_actor.txt
ls out
tail -n +2 clean_data.tsv | cut -f9 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr | head -1 >> out/6_director_actor.txt
echo "" >> out/6_director_actor.txt
echo "Diễn viên đóng nhiều phim nhất:" >> out/6_director_actor.txt
tail -n +2 clean_data.tsv | cut -f7 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr | head -1 >> out/6_director_actor.txt
cat out/6_director_actor.txt
tail -n +2 clean_data.tsv | cut -f14 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr
echo "Số lượng phim sắp xếp theo thể loại:" > out/7_genres.txt
tail -n +2 clean_data.tsv | cut -f14 | tr '|' '\n' | awk 'NF' | sort | uniq -c | sort -nr >> out/7_genres.txt
cat out/7_genres
cat out/7_genres.txt
ls out 
