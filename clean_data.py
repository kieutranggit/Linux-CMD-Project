import csv
with open("tmdb-movies.csv", encoding="utf-8", newline="") as fin:
	with open("clean_data.tsv","w", encoding="utf-8") as fout:
		reader = csv.reader(fin)
		for row in reader:
			new_row = []
			for cell in row:
				cell = cell.replace("\n", "")
				cell = cell.replace("\r", "")
				cell = cell.replace("\t", "")
				new_row.append(cell)
			fout.write("\t".join(new_row) + "\n")
