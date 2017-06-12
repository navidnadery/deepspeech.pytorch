FROM recog/pytorch

WORKDIR /workspace
RUN git clone https://github.com/recognai/warp-ctc.git \
	&& mkdir warp-ctc/build
WORKDIR  warp-ctc/build

RUN cmake .. \
	&& make \
	&& export CUDA_HOME="/usr/local/cuda" 
	
WORKDIR ../pytorch_binding
	
RUN pip install cffi && python setup.py install

WORKDIR /workspace
RUN apt-get update \
	&& apt-get install -q -y sox libsox-dev libsox-fmt-all \
	&& git clone https://github.com/pytorch/audio.git 
WORKDIR audio

RUN python setup.py install

WORKDIR /workspace

COPY . deepspeech.pytorch
WORKDIR deepspeech.pytorch

RUN pip install -r requirements.txt
