import os
from pytesseract import pytesseract
from openai import OpenAI
from part_examples import examples
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import json
import pprint
import pdb

execfile("./env.py")
execfile("./env.local.py")




def get_json_from_image(image_path, verbose=False):
    imgs = get_cropped_images(image_path)
    raw_text = ""
    for img in imgs:
        raw_text += "\n\n" + pytesseract.image_to_string(img)
    result = convert_to_json(raw_text)
    if verbose:
        print(raw_text)
        pp(result)
    return result



def get_cropped_images(image_path):
    img = mpimg.imread(image_path)
    img1 = img[50:250, 470:1050]
    img2 = img[250:950, 470:740]
    img3 = img[250:950, 740:1050]
    return [img1, img2, img3]

def convert_to_json(raw_text):
    client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    # remap examples
    messages = []
    for example in examples:
        messages.append({"role": "user", "content": example["input"]})
        messages.append({"role": "assistant", "content": json.dumps(example["output"])})
    messages.append({"role": "user", "content": raw_text})


    completion = client.chat.completions.create(
        model=os.getenv("OPENAI_MODEL"),
        messages=messages
    )

    content = completion.model_dump()["choices"][0]["message"]["content"]


    return json.loads(content)

def pp(x):
    printer = pprint.PrettyPrinter(indent=4, width=120, compact=False)
    printer.pprint(x)