# special_topics_final_project
## Exploring Linguistic Transfer Through Word Bigrams and Error Types in Native Language Identification

Folder of Corpus Data: soraUVALAL

### Script 1
Script 1: pp_dc_insp.sh

This script takes all the folders with written files from the soraUVALAL corpus, separates the files based on if they're training data or blind data, cleans the text so that all text is lowercase, removes special characters and 'chi:' at the beginning of lines, coverts all L1 words to the string L1, and removes all extra spaces.

Output of Script 1: cleaned_insp_files/

The output of this script contains text with incorrect spelling (insp).

### Script 2
Script 2: pp_dc_cosp.sh

This script takes all the folders with written files from the soraUVALAL corpus, separates the files based on if they're training data or blind data, cleans the text so that all text is lowercase, removes special characters, words to the right of bracketed-word (incorrectly spelled word), 'chi:' at the beginning of lines, and extra spaces.

Output of Script 2: cleaned_cosp_files/

### Python Code 1
Python Code 1: insp_training_data_csv.ipynb

This python code converts the cleaned_insp_files into a csv file that has a columns for file_name, language, label (0 for Spanish, 1 for Bosnian, 2 for Danish), and text.

Output of Python Code (2 csv files): insp_files_c1_training_data.csv & insp_files_c1_blind_data.csv

### Python Code 2
Python Code 2: fp_random_forest_td_bd_no_sc_Word_bigrams_SVM.ipynb

This python code uses a Support Vector Machine (SVM) model and trains on the training data and tests on the blind set on different kernels (linear and rbf) and C-parameters using bigrams as a feature. The code also creates a matrix of the bigrams and outputs them into a csv file (td_bigram_feature_martix_1.csv)". Additionally, this code uses random forest to analyze the word bigram features by importance.

### Python Code 3
Python Code 3: fp_td_no_sc_Word_bigrams_SVM.ipynb

This python code is similar to 'Python Code 2', except that it test on a validation set and uses Leave-One-Out Cross-Validation.

### Error Types CSV
CSV: error_types.csv

This is a csv file of the error types that has columns for language, incorrectly spelled word, correctly spelled word,type of error (draft), occurence count, and errors (final).
