#!/bin/bash
# The following script can be used to create the training-developing-testing
# splits used in Zhang et al. (submitted):
#
# "In most experiments we train using the first file for English (about 10
# million tokens) and the first four files for Russian (about 11 million
# tokens), and evaluate on the first 92,000 tokens of the last file for English,
# and the first 93,000 tokens of the last file for Russian."
#
# But due to <eos> symbols we actually want 100002 and 10007, respectively.
 
set -e -u
 
echo -n "Downloading and decompressing..."
curl -sO https://storage.googleapis.com/text-normalization/en_with_types.tgz && \
  tar -xzf en_with_types.tgz &
curl -sO https://storage.googleapis.com/text-normalization/ru_with_types.tgz && \
  tar -xzf ru_with_types.tgz &
wait
echo "done"
 
cd en_with_types
cp output-00000-of-00100 training &
cat output-0009[0-4]-of-00100 > development & 
head -100002 output-00099-of-00100 > evaluation &
wait
echo "English:"
wc -l training development evaluation
 
cd ../ru_with_types
cp output-00000-of-00100 training &
cat output-0009[0-4]-of-00100 > development &
head -100007 output-00099-of-00100 > evaluation &
wait
echo "Russian:"
wc -l training development evaluation
 
cd ..
rm -r en_with_types.tgz ru_with_types.tgz
