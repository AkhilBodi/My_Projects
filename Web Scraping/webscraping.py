from bs4 import BeautifulSoup
import requests
import csv

source = requests.get("https://coreyms.com/").text

soup = BeautifulSoup(source, "lxml")

csv_file = open("cms_scrape.csv", "w")
csv_writer = csv.writer(csv_file)
csv_writer.writerow(["Topic", "Synopsis", "Video link (youtube)"])

for article in soup.find_all("article"):
    headline = article.h2.a.text
    print(headline)

    summary = article.find("div", class_= "entry-content").text
    print(summary)
    try:
        video_source = article.find('iframe', class_= "youtube-player")["src"]
        video_id = video_source.split("/")[4]
        video_id = video_id.split("?")[0]

        youtube_link = f'https://youtube.com/watch?v={video_id}'

    except Exception as e:
        youtube_link = None

    print(youtube_link)

    print()
    csv_writer.writerow([headline, summary, youtube_link])

csv_file.close()
