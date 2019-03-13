#PBS -N darknet_uwrt
#PBS -l walltime=1:00:00
#PBS -l mem=16gb
#PBS -l nodes=1:ppn=40:gpus=2
#PBS -m abe

# Cuda versions on the OSC Pitzer computer: 10.0.130, 9.2.88, 9.1.85, 9.0.176
# The NVIDIA Tesla V100 GPUs currently have cuda 10.0 installed
# MUST use GNU versions earlier than 6
# The second export line is used by the darknet/Makefile
export cuda_version=cuda/10.0.130
export cuda_path_osc=/apps/${cuda_version}
module load gnu/4.8.5
module load ${cuda_version}

# In case this is needed
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${cuda_path_osc}/lib64"

cd $PBS_O_WORKDIR
cp darknet.zip $TMPDIR
cd $TMPDIR
unzip darknet.zip # TODO: Maybe do this before submitting job, to not waste time and $$ from SimCenter
cd darknet/
make
./darknet detector train uwrt/RS2018.data uwrt/yolov3-tiny_RS2018.cfg uwrt/yolov3-tiny.conv.15 -gpus 0,1
cp -r $TMPDIR $PBS_O_WORKDIR

# NOTE: darknet/src/network.c:402 commented out
# Note: Change number of max_batches in yolo*.cfg file as needed