# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "numpy",
#     "onnxruntime",
#     "pandas",
#     "huggingface-hub",
#     "pillow",
# ]
# ///

import os
import sys

import numpy as np
import onnxruntime as ort
import pandas as pd
from huggingface_hub import hf_hub_download
from PIL import Image

MODEL_REPO = "SmilingWolf/wd-swinv2-tagger-v3"
THRESHOLD = 0.35


def load_model():
    model_path = hf_hub_download(MODEL_REPO, "model.onnx")
    tags_path = hf_hub_download(MODEL_REPO, "selected_tags.csv")
    session = ort.InferenceSession(model_path, providers=["CPUExecutionProvider"])
    tags_df = pd.read_csv(tags_path)
    tags = tags_df["name"].tolist()
    return session, tags


def preprocess_image(image_path, target_size=448):
    img = Image.open(image_path).convert("RGBA")
    new_img = Image.new("RGBA", img.size, "WHITE")
    new_img.paste(img, (0, 0), img)
    img = new_img.convert("RGB")

    max_dim = max(img.size)
    pad_img = Image.new("RGB", (max_dim, max_dim), (255, 255, 255))
    pad_img.paste(img, ((max_dim - img.size[0]) // 2, (max_dim - img.size[1]) // 2))

    img = pad_img.resize((target_size, target_size), Image.Resampling.BICUBIC)

    img_array = np.array(img, dtype=np.float32)
    img_array = img_array[:, :, ::-1]
    img_array = np.expand_dims(img_array, axis=0)
    return img_array


def main():
    session, tags_list = load_model()
    input_name = session.get_inputs()[0].name

    valid_exts = {".png", ".jpg", ".jpeg", ".webp"}
    target_dir = os.getcwd()
    files = [
        f
        for f in os.listdir(target_dir)
        if os.path.splitext(f)[1].lower() in valid_exts
    ]

    if not files:
        return

    for idx, file in enumerate(files, 1):
        try:
            file_path = os.path.join(target_dir, file)
            img_tensor = preprocess_image(file_path)

            preds = session.run(None, {input_name: img_tensor})[0][0]

            valid_tags = [
                tags_list[i].replace(" ", "_").replace(",", "")
                for i, p in enumerate(preds)
                if p > THRESHOLD and i >= 4
            ]

            if valid_tags:
                tags_str = " ".join(valid_tags)
                print(f"{file}|{tags_str}")

        except Exception as e:
            print(f"{file}: {e}", file=sys.stderr)


if __name__ == "__main__":
    main()
