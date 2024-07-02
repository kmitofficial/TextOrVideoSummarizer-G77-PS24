# import requests
# import re

# channel = "https://www.youtube.com/user/PewDiePie"

# html = requests.get(channel + "/videos").text
# info = re.search('(?<={"label":").*?(?="})', html).group()
# url = "https://www.youtube.com/watch?v=" + re.search('(?<="videoId":").*?(?=")', html).group()

# print(info)
# print(url)x


import os
import requests
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials

# YouTube Data API key
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv('YT_API_KEY')

# Channel ID of the channel you want to monitor
CHANNEL_ID = "Jordindian"

# File to store the ID of the latest video
STORE_FILE = "latest_video_id.txt"

def get_channel_id(username):
    youtube = build('youtube', 'v3', developerKey=API_KEY)
    request = youtube.channels().list(
        part="id",
        forUsername=username
    )
    response = request.execute()

    if response['items']:
        channel_id = response['items'][0]['id']
        return channel_id
    else:
        return None


# Function to fetch the latest video ID from the API
def get_latest_video_id():
    youtube = build('youtube', 'v3', developerKey=API_KEY)
    request = youtube.search().list(
        part="snippet",
        channelId=get_channel_id(CHANNEL_ID),
        order="date",
        type="video",
        maxResults=1
    )
    response = request.execute()
    latest_video_id = response['items'][0]['id']['videoId']
    return latest_video_id

# Function to send push notification
def send_push_notification(video_id):
    # Replace this with your push notification service code
    # For example, you can use Pushbullet, Pushover, or any other service you prefer
    # Here, we'll just print the video ID as a placeholder
    print("New video uploaded! Video ID:", video_id)

# Function to check if a new video is uploaded
def check_new_video():
    latest_video_id = get_latest_video_id()

    try:
        with open(STORE_FILE, 'r') as f:
            stored_video_id = f.read()
    except FileNotFoundError:
        stored_video_id = None

    if stored_video_id != latest_video_id:
        send_push_notification(latest_video_id)
        with open(STORE_FILE, 'w') as f:
            f.write(latest_video_id)

# Main function to run the script
def main():
    check_new_video()

if __name__ == "__main__":
    main()
