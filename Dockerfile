#FROM recog/pytorch
FROM recog/pytorch:py3.5-gpu-cuda8

ENV DEBIAN_FRONTEND noninteractive
ENV CUDA_HOME /usr/local/cuda

RUN apt-get update && apt-get install -q -y \
    sox libsox-dev libsox-fmt-all gcc-4.8 g++-4.8 cmake git \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50 \
    && git clone https://github.com/recognai/warp-ctc.git /workspace/warp-ctc \
	&& git clone https://github.com/pytorch/audio.git /workspace/audio \
	&& mkdir -p /workspace/warp-ctc/build \
	&& rm -rf /usr/local/lib/python3.5/dist-packages/torch/lib/libgomp.so.1

WORKDIR /workspace/warp-ctc/build
RUN cmake .. && make

WORKDIR ../pytorch_binding
RUN pip install cffi && python setup.py install

WORKDIR /workspace/audio
RUN python setup.py install

WORKDIR /workspace

COPY . deepspeech.pytorch
WORKDIR deepspeech.pytorch

RUN pip install -r requirements.txt
