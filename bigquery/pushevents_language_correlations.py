'''
Correlations of the top 25 popular languages on GitHub (2013)
 
Reference: 	http://datahackermd.com/2013/language-use-on-github/
			http://www.coreyford.name/2013/04/13/github-language-correlations.html
 
'''

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

def plot_correlation(dataframe, filename, title='', corr_type=''):
    lang_names = dataframe.columns.tolist()
    tick_indices = np.arange(.5, len(lang_names) + .5)
    plt.figure()
    plt.pcolor(dataframe.values, cmap='PiYG', vmin=-.2, vmax=.2)
    colorbar = plt.colorbar()
    colorbar.set_label(corr_type, fontsize=10)
    colorbar.ax.tick_params(labelsize=10) 
    plt.title(title, fontsize=12)
    plt.xticks(tick_indices, lang_names, rotation='vertical', fontsize=6)
    plt.yticks(tick_indices, lang_names, fontsize=6)
    plt.savefig(filename)
    
def main():
    pushes = pd.read_csv('pushevents_by_actor_language.csv').pivot(
        index='actor',
        columns='repository_language',
        values='pushes_by_lang')
 
    toplangs = pushes.select(
			lambda x: np.sum(pushes[x]) > 65000, axis=1).fillna(0)
 
    pearson_corr = toplangs.corr()
    plot_correlation(
        pearson_corr,
        'pushevents_language_correlations_pearson.png',
        title='Correlation Matrix of Top 25 GitHub Languages (2013)',
        corr_type='Pearson\'s Correlation')
 
    spearman_corr = toplangs.corr(method='spearman')
    plot_correlation(
        spearman_corr,
        'pushevents_language_correlations_spearman.png',
        title='Correlation Matrix of Top 25 GitHub Languages (2013)',
        corr_type='Spearman\'s Rank Correlation')
 
 
if __name__ == '__main__':
    main() 