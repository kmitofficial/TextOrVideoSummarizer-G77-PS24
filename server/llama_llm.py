from langchain.document_loaders import SeleniumURLLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.llms.llamacpp import LlamaCpp
from langchain.chains.summarize import load_summarize_chain
from langchain.docstore.document import Document
from urllib.parse import unquote
from langchain import PromptTemplate

def extract_data_website(url):
    loader=SeleniumURLLoader([url])
    data=loader.load()
    text=""
    for page in data:
        text +=page.page_content + " "
        return text
    
def summarize_llama(text):
    text_chunks = split_text_chunks(text)

    llm = LlamaCpp(
    model_path="models/llama-2-7b-chat.Q4_0.gguf",
    n_ctx=10240,
    device="mps",
    n_batch=256,
    n_gpu_layers=32,
    verbose=True,  
    max_tokens=512,
)
    prompt_template = """Write a concise summary of the following text delimited by triple backquotes.
              Return your response in bullet points which covers the key points of the text.
              ```{text}```
              BULLET POINT SUMMARY:
  """

    prompt = PromptTemplate(template=prompt_template, input_variables=["text"])

    docs = [Document(page_content=t) for t in text_chunks]
    chain=load_summarize_chain(llm=llm, chain_type='stuff', verbose=True,prompt=prompt)
    summary = chain.run(docs)
    return summary


def split_text_chunks(text):
    text_splitter=CharacterTextSplitter(separator='\n',
                                        chunk_size=1000,
                                        chunk_overlap=20)
    text_chunks=text_splitter.split_text(text)
    return text_chunks

def mind_map_llama(text):
    text_chunks = split_text_chunks(text)

    llm = LlamaCpp(
    model_path="models/llama-2-7b-chat.Q4_0.gguf",
    n_ctx=10240,
    device="mps",
    n_batch=256,
    n_gpu_layers=32,
    verbose=True,  
    max_tokens=512,
    )
    prompt_template = """Generate a mind map from the following text and return me a markdown format mind map only:
              ```{text}```
              Markdown Mind Map:
    """

    prompt = PromptTemplate(template=prompt_template, input_variables=["text"])

    docs = [Document(page_content=t) for t in text_chunks]
    chain=load_summarize_chain(llm=llm, chain_type='stuff', verbose=True,prompt=prompt)
    summary = chain.run(docs)
    return summary