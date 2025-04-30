# NL2Bash (Enhanced Fork for Purple Teaming)

**Note:** This repository is a fork of the original [NL2Bash project](https://github.com/TellinaTool/nl2bash). This version is being enhanced and adapted with a focus on purple team cybersecurity applications and security best practices.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Overview

This repository contains the data and source code originally released with the paper: [NL2Bash: A Corpus and Semantic Parser for Natural Language Interface to the Linux Operating System](http://victorialin.net/pubs/nl2bash.pdf).

This fork aims to enhance and adapt the original NL2Bash project, tailoring its capabilities for purple team cybersecurity exercises, analysis, and improving overall security posture. It builds upon the original components:

1.  A set of ~10,000 bash one-liners collected from websites such as StackOverflow paired with their English descriptions written by Bash programmers. (This dataset forms the foundation for understanding command structures relevant to security analysis).
2.  Tensorflow implementations of the following translation models:
    * the standard [Seq2Seq](https://arxiv.org/abs/1409.0473) and [CopyNet](https://arxiv.org/abs/1603.06393) models
    * a stage-wise NL⟶Bash model using argument filling heuristics (Lin et. al. 2017).
    (Enhancements may focus on adapting these models for security-specific commands and natural language queries.)
3.  A Bash command parser which parses a Bash command into an abstractive syntax tree, developed on top of [bashlex](https://github.com/idank/bashlex). (Potentially improved for parsing complex or obfuscated commands seen in security contexts).
4.  A set of domain-specific natural language processing tools, including a regex-based sentence tokenizer and a domain specific named entity recognizer. (Adaptations may include recognizing security-related entities like IOCs, TTPs, etc.).

You may visit http://tellina.rocks to interact with the *original* pretrained model. Work may be undertaken in this fork to host models trained with the specific enhancements developed here.

**🆕 Apr 24, 2020 (Original Project Update)** The dataset `data/bash` from the original project is separately licensed under the MIT license. Please review the licensing terms for any components used or modified in this fork.

## Data Statistics (Original Corpus)

The original corpus contains a diverse set of Bash utilities and flags: 102 unique utilities, 206 unique flags and 15 reserved tokens. (Browse the raw data collection [here](https://github.com/TellinaTool/nl2bash/tree/master/data/bash).)

In the original experiments, the set of ~10,000 NL-bash command pairs were splitted into train, dev and test sets such that *neither a natural language description nor a Bash command appears in more than one split*.

The statistics of the original data split is tabulated below. (A command template is defined as a Bash command with all of its arguments replaced by their semantic types.)

<table>
   <tr>
      <td><strong>Split</strong></td>
      <td>Train</td>
      <td>Dev</td>
      <td>Test</td>
   </tr>
   <tr>
      <td># pairs</td>
      <td>8,090</td>
      <td>609</td>
      <td>606</td>
   </tr>
   <tr>
      <td># unique NL</td>
      <td>7,340</td>
      <td>549</td>
      <td>547</td>
   </tr>
   <tr>
      <td># unique command</td>
      <td>6,400</td>
      <td>599</td>
      <td>XX</td>
   </tr>
   <tr>
      <td># unique command template</td>
      <td>4,002</td>
      <td>509</td>
      <td>XX</td>
   </tr>
</table>

The frequency of the top 50 most frequent Bash utilities in the original corpus is illustrated in the following diagram.

<p align="left">
  <img src="http://victorialin.net/img/github/nl2bash-utility-dist2.png" width="320" title="NL2Bash utility distribution (Original Corpus)">
</p>

## Leaderboard (Based on Original Paper)

These results reflect the performance reported in the original NL2Bash paper. Enhancements in this fork will aim to improve upon these, potentially with new metrics relevant to security applications.

### Manually Evaluated Translation Accuracy (Original)

Top-k full command accuracy and top-k command template accuracy judged by human experts. Please refer to section 4 of the original paper for the exact procedures taken for manual evaluation.

<table>
   <tr>
      <td>Model</td>
      <td>F-Acc-Top1</td>
      <td>F-Acc-Top3</td>
      <td>T-Acc-Top1</td>
      <td>T-Acc-Top3</td>
   </tr>
   <tr>
      <td>Sub-token CopyNet (Original Work)</td>
      <td><strong>0.36</strong></td>
      <td><strong>0.45</strong></td>
      <td>0.49</td>
      <td>0.61</td>
   </tr>
   <tr>
      <td>Tellina (Lin et. al. 2017)</td>
      <td>0.27</td>
      <td>0.32</td>
      <td><strong>0.53</strong></td>
      <td><strong>0.62</strong></td>
   </tr>
</table>

⚠️ If you plan to run manual evaluation yourself, please refer to ["Notes on Manual Evaluation"](#notes-on-manual-evaluation) for issues you should pay attention to, adapting as necessary for security-focused evaluations.

### Automatic Evaluation Metrics (Original)

The original paper also reported [*character-based* BLEU](https://github.com/TellinaTool/nl2bash/blob/master/eval/eval_tools.py#L343) and a self-defined template matching score. Please refer to appendix C of the original paper for the metrics definitions.

<table>
   <tr>
      <td>Model</td>
      <td>BLEU-Top1</td>
      <td>BLEU-Top3</td>
      <td>TM-Top1</td>
      <td>TM-Top3</td>
   </tr>
   <tr>
      <td>Sub-token CopyNet (Original Work)</td>
      <td><strong>50.9</strong></td>
      <td><strong>58.2</strong></td>
      <td>0.574</td>
      <td>0.634</td>
   </tr>
   <tr>
      <td>Tellina (Lin et. al. 2017)</td>
      <td>48.6</td>
      <td>53.8</td>
      <td><strong>0.625</strong></td>
      <td><strong>0.698</strong></td>
   </tr>
</table>

## Run Experiments (Getting Started with Original Setup)

### Install TensorFlow (Check Requirements)

To reproduce the original experiments, TensorFlow 2.0 was required. Check the current requirements for this fork if modifications have been made. The original experiments could run on CPU or GPU, but training was significantly faster with GPU.

Follow the [official TensorFlow instructions](https://www.tensorflow.org/install/) for installation, ensuring compatibility with your system (e.g., CUDA/CUDNN versions if using GPU). The original code was tested on Ubuntu 16.04 + CUDA 10.0 + CUDNN 7.6.3.

### Environment Variables & Dependencies

Set up the Python path and install dependencies based on the original project (adapt if this fork has different requirements).
```bash
# Ensure PYTHONPATH includes the project root
export PYTHONPATH=`pwd`:$PYTHONPATH
```
# Install dependencies (original method)
# Review the Makefile and requirements for this fork
(sudo) make

Change Directory
Navigate to the scripts directory (or as specified by this fork's structure).
```bash
cd scripts
```
Data filtering, split and pre-processing (Original Workflow)
This command runs the original data preparation pipeline. Modifications in this fork might require different steps.
make data

To change the data-processing workflow, examine the scripts in the data directory (or relevant location in this fork) and modify the utility scripts as needed.
Train models (Original Workflow)
```bash
make train
```
Evaluate models (Original Workflow)
The original project provided evaluation scripts. Adapt these or use new ones developed for this fork's goals.
To use the original evaluation scripts, save your model output to a file (example). The expected format was:
1. The i-th line contains predictions for example i in the dataset.
2. Each line contains top-k predictions separated by "|||".

Then use the bash-run.sh script (adjust paths and flags as needed):
Manual (Original Method)

Dev set evaluation
```bash
./bash-run.sh --data bash --prediction_file <path_to_your_model_output_file> --manual_eval
```
Test set evaluation
```bash
./bash-run.sh --data bash --prediction_file <path_to_your_model_output_file> --manual_eval --test
```
Automatic (Original Method)
Dev set evaluation
./bash-run.sh --data bash --prediction_file <path_to_your_model_output_file> --eval

Test set evaluation
./bash-run.sh --data bash --prediction_file <path_to_your_model_output_file> --eval --test

Generate evaluation table using pre-trained models (Original Method)
Decode the original pre-trained models and print the evaluation summary table.
make decode

Skip decoding and print the table from existing prediction files.
make gen_manual_evaluation_table

The original decoding/evaluation steps had verbose output. You could set verbose to False in encoder_decoder/decode_tools.py and eval/eval_tools.py to suppress messages (check if these files/settings exist or have changed in this fork).
Notes on Manual Evaluation
Conducting manual evaluation is crucial as simple string matching often fails to capture the correctness of Bash commands, especially in security contexts where intent and effect matter. The original project suggested:
 * Evaluate outputs from both your system(s) and baselines using the same annotators for fair comparison.
 * Release annotated examples (original example) to aid reproducibility and reuse. Consider formats suitable for security findings.
 * During development, annotate a smaller subset (e.g., 50-100 dev examples) to estimate performance. The original project provided a script (manual_eval.md) for this – adapt or create tools suitable for purple team analysis.
See original issue #6 for more motivation.
Citation (Original Work)
If you use the original data or source code foundational to this fork, please cite the original paper:
@inproceedings{LinWZE2018:NL2Bash,
  author = {Xi Victoria Lin and Chenglong Wang and Luke Zettlemoyer and Michael D. Ernst},
  title = {NL2Bash: A Corpus and Semantic Parser for Natural Language Interface to the Linux Operating System},
  booktitle = {Proceedings of the Eleventh International Conference on Language Resources
               and Evaluation {LREC} 2018, Miyazaki (Japan), 7-12 May, 2018.},
  year = {2018}
}

Related paper: Lin et. al. 2017. Program Synthesis from Natural Language Using Recurrent Neural Networks.
Please also consider citing this fork if you use the specific enhancements or modifications developed here (provide citation details specific to this fork).
Changelog (Original Project)
 * Apr 24, 2020 The dataset data/bash is separately licensed under the terms of the MIT license.
 * Oct 20, 2019 release standard evaluation scripts
 * Oct 20, 2019 update to Tensorflow 2.0
(Add a Changelog for this Fork below to track enhancements)
Changelog (This Fork)
 * [Date] - Initial fork created. Focus defined: Purple Team enhancements, security best practices.
 * (Add further changes here)

