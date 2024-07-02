from youtube_transcript_api import YouTubeTranscriptApi

def get_transcript(video_id):

    transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)
    x = ''
    for transcript in transcript_list:

        print(
            transcript.video_id,
            transcript.language,
            transcript.language_code,

            transcript.is_generated,

            transcript.is_translatable,
        )

        # print(transcript.translate('en').fetch())
        # with open("subtitles.txt", "w") as f:
        for caption in transcript.translate('en').fetch():
            # f.write(caption['text'] + '\n')
            x += caption['text'] + '\n'
    
    return x

