#PBS -N darknet_uwrt
#PBS -l walltime=1:00:00
#PBS -l mem=16gb
#PBS -l nodes=1:ppn=1:gpus=2
#PBS -m abe

# Cuda versions on the OSC Pitzer computer: 10.0.130, 9.2.88, 9.1.85, 9.0.176
# Must use GNU versions earlier than 6
export cuda_version=cuda/10.0.130
export cuda_osc=/apps/${cuda_version}
module load ${cuda_version}
module load gnu/4.8.5

cd $PBS_O_WORKDIR
cp darknet.zip $TMPDIR
cd $TMPDIR
unzip darknet.zip
cd darknet/
make
./darknet detector train uwrt/RS2018.data uwrt/yolov3-tiny_RS2018.cfg uwrt/yolov3-tiny.conv.15 -gpus 0, 1
cp -r $TMPDIR $PBS_O_WORKDIR