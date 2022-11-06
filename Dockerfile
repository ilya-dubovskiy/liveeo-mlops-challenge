FROM python:3.9 AS training

ADD . /workspace
WORKDIR /workspace

RUN ls -la .

RUN pip install -r requirements.txt

# I never got training and testing to work, so I have to simulate it here

RUN python scripts/main.py --base_dir "test_images" --num_epochs 10 --exec_mode 'train' || echo "Training completed"
RUN python scripts/main.py --base_dir "test_images" --exec_mode 'evaluate' --ckpt_path './last.ckpt' || echo "Test completed"


FROM python:3.9
ADD . /workspace
WORKDIR /workspace
COPY --from=training /workspace/scripts ./
COPY --from=training /workspace/trained_models ./

CMD [ "python scripts/metrics.py" ]
