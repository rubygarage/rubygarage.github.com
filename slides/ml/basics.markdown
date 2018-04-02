---
layout: slide
title: ML Basics
---

![](/assets/images/ml/ml-python-stack.png)

# Machine Learning

---

# What do we need for start?

--

## Installation

- [Anaconda](https://www.anaconda.com/download) - The most of python packages we need already exists in this package
- [Kaggle](https://www.kaggle.com/) - we need an account for competitions
- [Kaggle API](https://github.com/Kaggle/kaggle-api) - API for uploading predictions to 
kaggle (optional)

--

## Downloading

- Visit [Titanic competitions](https://www.kaggle.com/c/titanic/data)
- Download `test.csv` and `train.csv` files
- Put them to folder

```sh
$ cd /Users/vlad.strelkov/Projects/trainings/ml
$ jupyter notebook
```

---

# Pandas

[Pandas](http://pandas.pydata.org/) is a Python library that provides extensive means 
for data analysis. Data scientists often work with data stored in table formats 
like `.csv`, `.tsv`, or `.xlsx`. Pandas makes it very convenient to load, process, 
and analyze such tabular data using SQL-like queries. 
In conjunction with Matplotlib and Seaborn, Pandas provides a wide range of opportunities
for visual analysis of tabular data.

---

# NumPy

[NumPy](http://www.numpy.org/) is the fundamental package for scientific computing 
with Python. It contains among other things:

1. a powerful N-dimensional array object
2. sophisticated (broadcasting) functions
3. tools for integrating C/C++ and Fortran code
4. useful linear algebra, Fourier transform, and random number capabilities

---

# Let's check our train data


```python
import numpy as np
import pandas as pd

data = pd.read_csv('./train.csv') # read data
data.head() # look at the first 5 lines 
```
![](/assets/images/ml/head-titanic-test-data.png)

--

### The [info()](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.info.html) method to output some general information

```python
print(df.info())
```

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 891 entries, 0 to 890
Data columns (total 12 columns):
PassengerId    891 non-null int64
Survived       891 non-null int64
Pclass         891 non-null int64
Name           891 non-null object
Sex            891 non-null object
Age            714 non-null float64
SibSp          891 non-null int64
Parch          891 non-null int64
Ticket         891 non-null object
Fare           891 non-null float64
Cabin          204 non-null object
Embarked       889 non-null object
dtypes: float64(2), int64(5), object(5)
memory usage: 83.6+ KB
None
```
--

The [describe()](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.describe.html) method shows basic statistical characteristics of each numerical feature 
(int64 and float64 types): number of non-missing values, mean, standard deviation, 
range, median, 0.25 and 0.75 quartiles.

```python
print(df.describe())
```

![](/assets/images/ml/describe-titanic-test-data.png) <!-- .element: style="height: 400px" -->

--

### The [mean()](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.mean.html) method returns the mean of the values for the requested axis

```python
data.Survived.mean()
```

```
0.3838383838383838
```

```python
data[data['Survived'] == 1].mean()
```

```
PassengerId    444.368421
Survived         1.000000
Pclass           1.950292
Age             28.343690
SibSp            0.473684
Parch            0.464912
Fare            48.395408
dtype: float64
```

--

## Visualization

```python
g = sns.FacetGrid(data, col='Survived')
g.map(plt.hist, 'Age', bins=20)
```

![](/assets/images/ml/titanic-survived-grid.png)

--

## Visualization

```python
grid = sns.FacetGrid(data, col='Survived', row='Pclass', size=2.2, aspect=1.6)
grid.map(plt.hist, 'Age', alpha=.5, bins=20)
grid.add_legend();
```

![](/assets/images/ml/titanic-pclass-survived-grid.png)

---

# Introduction

## Some of the most popular tasks T in machine learning are the following:

1. `Classification` of an instance to one of the categories based on its features;
2. `Regression` — prediction of a numerical target feature based on other features of an instance;
3. `Clustering` — identifying partitions of instances based on the features of these instances so that the members within the groups are more similar to each other than those in the other groups;
4. `Anomaly detection` — search for instances that are “greatly dissimilar” to the rest of the sample or to some group of instances;
5. And so many more.

--

# Classification

### In classification problems we are trying to predict a discrete number of values.

1. `Binary Classification` — when there is only two classes to predict, usually 1 or 0 values.
2. `Multi-Class Classification` — when there are more than two class labels to predict we 
call multi-classification task. E.g. predicting 3 types of iris species, 
image classification problems where there are more than thousands 
classes(cat, dog, fish, car,…).

---

# Decision Tree

We begin our overview of `classification` method with one of the most 
popular ones — a `decision tree`. Decision trees are used in everyday life decisions, 
not just in machine learning. Flow diagrams are actually visual representations of 
decision trees.

![](/assets/images/ml/decision-tree-1.png)

--

# Entropy

### Shannon’s entropy is defined for a system with `N` possible states as follows:

$$
\Large S = -\sum_{i=1}^{N}p_i \log_2{p_i},
$$

where `p(i)` is the probability of finding the system in the `i`-th state. 
This is a very important concept used in physics, information theory, and other areas. 
Entropy can be described as the degree of chaos in the system. 
The higher the entropy, the less ordered the system and vice versa.

--

## Example of entropy calculation 

To illustrate how entropy can help us identify good features for building a decision tree, 
let’s look at a toy example. We will predict the color of the ball based on its position.

![](/assets/images/ml/entropy-balls-example.png)

There are 9 blue balls and 11 yellow balls. If we randomly pull out a ball, then it will 
be blue with probability `p1 = 9/20` and yellow with probability `p2 = 11/20`, which gives
us an entropy 

$$
S_0 = -\frac{9}{20}\log_2{\frac{9}{20}}-\frac{11}{20}\log_2{\frac{11}{20}} \approx 1
$$

--

## Example of entropy calculation 

![](/assets/images/ml/entropy-1.png)

The left group has 13 balls, 8 blue and 5 yellow. The entropy of this group is 
$$
S_1 = -\frac{5}{13}\log_2{\frac{5}{13}}-\frac{8}{13}\log_2{\frac{8}{13}} \approx 0.96
$$
The right group has 7 balls, 1 blue and 6 yellow. The entropy of the right group is 
$$
S_2 = -\frac{1}{7}\log_2{\frac{1}{7}}-\frac{6}{7}\log_2{\frac{6}{7}} \approx 0.6 
$$

Entropy has decreased in both groups, more so in the right group. 
Since entropy is, in fact, the degree of chaos (or uncertainty) in the system, the 
reduction in entropy is called information gain.

--

## Information gain (IG)

### Formally, the information gain `IG` for a split based on the variable `Q` 

![](/assets/images/ml/ig-info-formula.png)

where `q` is the number of groups after the split, `N(i)` is number of objects from 
the sample in which variable `Q` is equal to the `i`-th value. In our example, 
our split yielded two groups (`q` = 2), one with 13 elements (`N1` = 13), the other with 
7 (`N2` = 7). Therefore, we can compute the information gain as

$$
\Large IG(x \leq 12) = S_0 - \frac{13}{20}S_1 - \frac{7}{20}S_2 \approx 0.16.
$$

--

## Let’s consider an example. Suppose we have the following dataset:

```python
data = pd.DataFrame({'Age': [17,64,18,20,38,49,55,25,29,31,33], 
             'Loan Default': [1,0,1,0,1,0,0,1,1,0,1]})
# Let's sort it by age in ascending order.
data.sort_values('Age')
```

![](/assets/images/ml/d-tree-age-example.png) <!-- .element: style="height: 400px" -->

--

## Code for visualize decision tree

```python
age_tree = DecisionTreeClassifier(random_state=17)
age_tree.fit(data['Age'].values.reshape(-1, 1), data['Loan Default'].values)
dot_data = StringIO()
export_graphviz(age_tree, feature_names=['Age'], 
                out_file=dot_data, filled=True)
graph = pydotplus.graph_from_dot_data(dot_data.getvalue())
Image(value=graph.create_png())
```
--

![](/assets/images/ml/d-tree-visualized.png)

--

## Class [DecisionTreeClassifier](http://scikit-learn.org/stable/modules/generated/sklearn.tree.DecisionTreeClassifier.html) in Scikit-learn

- `max_depth` – the maximum depth of the tree;

- `max_features` – the maximum number of features with which to search for the best partition (this is necessary with a large number of features because it would be "expensive" to search for partitions for all features);
- `min_samples_leaf` – the minimum number of samples in a leaf. This parameter prevents creating trees where any leaf would have only a few members.

---

# Ensembles

An observation known as Wisdom of the crowd. 
In 1906, Francis Galton visited a country fair in Plymouth where he saw a contest 
being held for farmers. 800 participants tried to estimate the weight of a slaughtered 
bull. The real weight of the bull was `1198` pounds. Although none of the farmers could 
guess the exact weight of the animal, the average of their predictions was `1197` pounds.

A similar idea for error reduction was adopted in the field of Machine Learning.

--

# Bootstrapping 

Let there be a sample `X` of size `N`. 
We can make a new sample from the original sample by drawing `N` elements 
from the latter randomly and uniformly, with replacement.
In other words, we select a random element from the original sample of size `N` 
and do this `N` times. All elements are equally likely to be selected, 
thus each element is drawn with the equal probability `1/N`.


By repeating this procedure `M` times, 
we create `M` bootstrap samples `X1, …, XM`. 
In the end, we have a sufficient number of samples and can compute 
various statistics of the original distribution.

--

# Bootstrapping

In machine learning, `the bootstrap method refers to random sampling with replacement`
![](/assets/images/ml/bootstrapping-1.png) <!-- .element: style="height: 500px" -->

--

# Bagging

1. Suppose that we have a training set:
$$ \large X $$

2. Using bootstrapping, we generate samples:
$$ \large X_1, \dots, X_M $$

3. Now, for each bootstrap sample, we train its own classifier: 
$$ \large a_i(x) $$

4. In the case of classification, this technique corresponds to voting: 
$$ \large a(x) = \frac{1}{M}\sum_{i = 1}^M a_i(x) $$

--

The picture below illustrates this algorithm:

![](/assets/images/ml/bagging-2.png)

--

# Total out-of-sample error

$$
\large \begin{array}{rcl} \text{Err}\left(\vec{x}\right) &=& \mathbb{E}\left[\left(y - \hat{f}\left(\vec{x}\right)\right)^2\right] \\\ &=& \sigma^2 + f^2 + \text{Var}\left(\hat{f}\right) + \mathbb{E}\left[\hat{f}\right]^2 - 2f\mathbb{E}\left[\hat{f}\right] \\\ &=& \left(f - \mathbb{E}\left[\hat{f}\right]\right)^2 + \text{Var}\left(\hat{f}\right) + \sigma^2 \\\ &=& \text{Bias}\left(\hat{f}\right)^2 + \text{Var}\left(\hat{f}\right) + \sigma^2 \end{array} 
$$

Bagging `reduces the variance of a classifier` by decreasing the difference in error when we 
train the model on different datasets. In other words, bagging prevents `overfitting`.

---

# Random forest

`Decision trees` are a good choice for the base classifier in bagging because they are 
quite sophisticated and can achieve zero classification error on any sample. 
The random subspace method reduces the correlation between the trees and thus 
prevents overfitting. With bagging, the base algorithms are trained on different 
random subsets of the original feature set.

--

## The following algorithm constructs an ensemble of models using the random subspace method:

1. Let the number of instance be equal to `N`
and the number of feature dimensions be equal to `D`
2. Choose `M` as the number of individual models in the ensemble.
3. For each model `m`, choose the number of features `dm < d`. 
As a rule, the same value of `dm` is used for all the models.
4. For each model `m`, create a training set by selecting `dm` features 
at random from the whole set of `d` features.
5. Train each model.
6. Apply the resulting ensemble model to a new input by combining the results 
from all the models in `M`. You can use either majority voting or aggregation 
of the posterior probabilities

--

## RF Algoritm

![](/assets/images/ml/rf-algoritm.png)

The final classifier is defined by:
$$ \large a(x) = \frac{1}{N}\sum_{i = 1}^N b_i(x) $$

--

## We use the `majority voting` for classification and the `mean` for regression.

For classification problems, it is advisable to set m to be equal the square root of `d`.
For regression problems, we usually take `m = d/3`, where d is the number of features. 
It is recommended to build each tree until all of its leaves contain only 1 instance
for classification and 5 instances for regression.

--

## Parameters

Below are the parameters which we need to pay attention to when we are building a new model:

- `n_estimators` - the number of trees in the forest
- `criterion` - the function used to measure the quality of a split
- `max_features` - the number of features to consider when looking for the best split
- `min_samples_leaf` - the minimum number of samples required to be at a leaf node
- `max_depth` - the maximum depth of the tree

---

# Let's prepare data

```python
train_df = pd.read_csv('./data/titanic_train.csv')
test_df = pd.read_csv('./data/titanic_test.csv')

train_df = train_df.drop(['Name', 'PassengerId', 'Ticket', 'Cabin'], axis=1)
test_df = test_df.drop(['Name', 'Ticket', 'Cabin'], axis=1)

combined = [train_df, test_df]
```

```python
for dataset in combined:
    dataset['Sex'] = dataset['Sex'].map( {'female': 1, 'male': 0} ).astype(int)
    dataset['Embarked'] = dataset['Embarked'].map( {'S': 0, 'C': 1, 'Q': 2, float("nan"): 3} ).astype(int)
    dataset['Fare'].fillna(dataset['Fare'].dropna().median(), inplace=True)
    dataset['Age'].fillna(dataset['Age'].dropna().median(), inplace=True)
```

--

## Prepare `X_train` and `Y_train`

```python
X_train = train_df.drop("Survived", axis=1)
Y_train = train_df["Survived"]
X_test  = test_df.drop("PassengerId", axis=1)
X_test_labels = test_df['PassengerId']
X_train.shape, Y_train.shape, X_test.shape
```

```
((891, 8), (891,), (418, 8))
```
---

# Setup Random Forest

```python
from sklearn.ensemble import RandomForestClassifier

rfc = RandomForestClassifier(criterion='entropy', random_state=41, n_jobs=-1)
rfc.fit(X_train, Y_train)
Y_pred = rfc.predict(X_test)
round(rfc.score(X_train, Y_train) * 100, 2)
```

```
86.76
```
--

## Hypermarameters optimization

```python
from sklearn.model_selection import GridSearchCV

def pretty_print(res):
    print('PARAMS | TRAIN | TEST')
    for i in range(len(res.cv_results_['mean_test_score'])):
        print('{} | {:.2f} | {:.2f}'.format(res.cv_results_['params'][i],
                                            res.cv_results_['mean_train_score'][i],
                                            res.cv_results_['mean_test_score'][i]
                                            ))
    print(res.best_params_)
    return res.best_params_

param_grid = [{
   'n_estimators': [5, 10, 15, 20, 30, 50, 75, 100, 200, 500, 1000],
   'max_features': [2, 3, 4, 5, 'auto'],
   'min_samples_leaf': [1, 5, 10, 20, 30]
}]
    
clf_CV = GridSearchCV(rfc, param_grid)
clf_CV.fit(x_train, y_train)
pretty_print(clf_CV)
```

--

## Best calculated hyperparameters

```
PARAMS | TRAIN | TEST
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 5} | 0.96 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 10} | 0.97 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 15} | 0.98 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 20} | 0.98 | 0.81
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 30} | 0.98 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 50} | 0.98 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 75} | 0.99 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 100} | 0.99 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 200} | 0.99 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 500} | 0.99 | 0.80
{'max_features': 2, 'min_samples_leaf': 1, 'n_estimators': 1000} | 0.99 | 0.80
{'max_features': 2, 'min_samples_leaf': 5, 'n_estimators': 5} | 0.85 | 0.79
{'max_features': 2, 'min_samples_leaf': 5, 'n_estimators': 10} | 0.86 | 0.81
{'max_features': 2, 'min_samples_leaf': 5, 'n_estimators': 15} | 0.87 | 0.81
{'max_features': 2, 'min_samples_leaf': 5, 'n_estimators': 20} | 0.87 | 0.81
{'max_features': 2, 'min_samples_leaf': 5, 'n_estimators': 30} | 0.87 | 0.80
{'max_features': 2, 'min_samples_leaf': 5, 'n_estimators': 50} | 0.87 | 0.80
{'max_features': 2, 'min_samples_leaf': 5, 'n_estimators': 75} | 0.87 | 0.81
{'max_features': 2, 'min_samples_leaf': 5, 'n_estimators': 100} | 0.87 | 0.81
....................................................................................
{'max_features': 5, 'min_samples_leaf': 5, 'n_estimators': 1000}
```

---

# Upload prediction to kaggle

```python
rfc = RandomForestClassifier(criterion='entropy', random_state=41, n_jobs=-1, 
                             n_estimators=1000, min_samples_leaf=5, max_features=3)
rfc.fit(X_train, Y_train)
Y_pred = rfc.predict(X_test)

submission = pd.DataFrame({
    "PassengerId": X_test_labels,
    "Survived": Y_pred
})

submission.to_csv('./data/test-titanic.csv', index=False)
```

```sh
$ kaggle competitions submit -c titanic -f './data/test-titanic.csv' -m "Upload my prediction"
```

---

# The End
