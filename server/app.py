from flask import Flask, jsonify, request
from langchain.document_loaders import SeleniumURLLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.llms.llamacpp import LlamaCpp
from langchain.chains.summarize import load_summarize_chain
from langchain.docstore.document import Document
from urllib.parse import unquote
from langchain import PromptTemplate
from transcript import get_transcript
from gemini_llm import summarize
from llama_llm import summarize_llama, extract_data_website, split_text_chunks
from pdfreader import read_pdf
from flask_cors import CORS
from dotenv import load_dotenv
import os
import flowchart

app=Flask(__name__)
cors = CORS(app, resources={r"*": {"origins": "*"}})

load_dotenv()

@app.route('/', methods=['GET', 'POST'])
def home():
    return "Summary Generator"

@app.route('/summary_generate', methods=['GET', 'POST'])
def summary_generator_url():
    encode_url=unquote(unquote(request.args.get('url')))
    if not encode_url:
        return jsonify({'error':'URL is required'}), 400
    text=extract_data_website(encode_url)
    #text_chunks=split_text_chunks(text)
    #print(len(text_chunks))
    summary=summarize_llama(text)
    # summary=summarize(text)
    print("Here is the Complete Summary", summary)
    response= {
        'submitted_url': encode_url,
        'summary': summary,
    }
    return jsonify(response)

@app.route('/api/get_yt_transcript', methods=['POST'])
def yttran():
    link = request.json['link']
    video_id = link
    for i in range(len(video_id)):
        if video_id[i] == "=":
            video_id = video_id[i+1:]
            break
    
    return jsonify({'transcript': get_transcript(video_id)})

@app.route('/api/get_yt_summary', methods=['POST'])
def api():

    link = request.json['link']
    video_id = link
    for i in range(len(video_id)):
        if video_id[i] == "=":
            video_id = video_id[i+1:]
            break
    summary = summarize_llama(get_transcript(video_id))
    # summary = summarize(get_transcript(video_id),key = os.getenv('GOOGLE_API_KEY'))
    print(summary)
    return jsonify({'transcript': get_transcript(video_id),
                    'summary': summary,
                    'link': link
                    })


@app.route('/api/pdfsummary', methods=['POST'])
def upload_pdf():
    if 'pdfFile' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    pdf_file = request.files['pdfFile']
    if pdf_file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if pdf_file and pdf_file.filename.endswith('.pdf'):
        try:
            extracted_text = read_pdf(pdf_file)
            summarized_text = summarize(extracted_text)
            print(summarized_text)
            return jsonify({'text': summarized_text}), 200
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    else:
        return jsonify({'error': 'File format not supported, please upload a PDF file'}), 400
    

@app.route('/generate-mind-map', methods=['POST'])
def generate_mind_map():
    data = request.json
    text = data.get('text')
    api_key = data.get('api_key')
    api_key = os.getenv('GOOGLE_API_KEY') 
    mind_map_code = flowchart.generate_mind_map_structure(text,api_key=os.getenv('GOOGLE_API_KEY'))
    print(mind_map_code)
    mind_map_code = mind_map_code.replace("```","")
    print(mind_map_code)
    
    return jsonify({"mind_map_code": mind_map_code})

if __name__ == '__main__':

    app.run(debug=True,host='0.0.0.0',port=8000)
