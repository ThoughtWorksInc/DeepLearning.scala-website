---
title: Announcing DeepLearning.scala 2.0.0
featured: images/pic01.jpg
layout: post
---

Today, we are happy to announce DeepLearning.scala 2.0.0, the new stable release of DeepLearning.scala, a simple library for creating complex neural networks from object-oriented and functional programming constructs.

* DeepLearning.scala runs on JVM, can be used either in standalone JVM applications or a Jupyter Notebooks.
* DeepLearning.scala is expressive. Various types of neural network layers can be created by composing `map`, `reduce` or other higher order functions.
* DeepLearning.scala supports plugins. You can share your own algorithms, models, hyperparameters as a plugin, as simple as creating a Github Gist.
* All the above features are statically type checked.

## Features in DeepLearning.scala 2.0

### Dynamic neural networks

Unlike some other deep learning frameworks, the structure of neural networks in DeepLearning.scala is dynamically determined during running. Our neural networks are programs. All Scala features, including functions and expressions, are available in neural networks.

For example:

``` scala
def ordinaryScalaFunction(a: INDArray): Boolean = {
  a.signnum.sumT > math.random
}

def myDynamicNeuralNetwork(input: INDArray) = INDArrayLayer(monadic[Do] {
  val outputOfLayer1 = layer1(input).forward.each
  if (ordinaryScalaFunction(outputOfLayer1.data)) {
    dynamicallySelectedLayer2(outputOfLayer1).forward.each
  } else {
    dynamicallySelectedLayer3(outputOfLayer1).forward.each
  }
})
```

The above neural network will go into different subnetworks according to an ordinary Scala function.

With the ability of creating dynamic neural networks, regular programmers are able to build complex neural networks from simple code. You write code almost as usual, the only difference being that code based on DeepLearning.scala is differentiable, which enables such code to evolve by modifying its parameters continuously.

### Functional programming

DeepLearning.scala 2.0 is based on Monads, which are composable, thus a complex layer can be built from primitive operators. Along with the Monad, we provide an Applicative type class, to perform multiple calculations in parallel.

For example, the previous example can be rewritten in higher-order function style as following:

``` scala
def myDynamicNeuralNetwork(input: INDArray) = INDArrayLayer {
  layer1(input).forward.flatMap { outputOfLayer1 =>
    if (ordinaryScalaFunction(outputOfLayer1.data)) {
      dynamicallySelectedLayer2(outputOfLayer1).forward
    } else {
      dynamicallySelectedLayer3(outputOfLayer1).forward
    }
  }
}
```

The key construct in DeepLearning.scala 2.0 is the dependent type class [DeepLearning](https://javadoc.io/page/com.thoughtworks.deeplearning/deeplearning_2.11/latest/com/thoughtworks/deeplearning/DeepLearning.html), which witnesses a differentiable expression. In other words, given the `DeepLearning` type class instance, you can activate the deep learning ability of any type.

### Object-oriented programming

The code base of DeepLearning.scala 2.0 is organized according to Dependent Object Type calculus (DOT). All features are provided as mixin-able plugins. A plugin is able to change APIs and behaviors of all DeepLearning.scala types. This approach not only resolves [expression problem](https://en.wikipedia.org/wiki/Expression_problem), but also gives plugins the additional ability of **virtually depending** on other plugins.

For example, when a plugin author is creating the [Adagrad](https://gist.github.com/Atry/89ee1baa4c161b8ccc1b82cdd9c109fe#file-adagrad-sc) optimizer plugin, he does not have to explicitly call functions related to learning rate. However, once a plugin user enables both the `Adagrad` plugin and the [FixedLearningRate](https://gist.github.com/Atry/1fb0608c655e3233e68b27ba99515f16#file-readme-ipynb) plugin, then computation in `FixedLearningRate` will get called eventually when the `Adagrad` optimization is executed.

### Static type system

As always, all of the above features are statically type checked.

## Plugins for DeepLearning.scala 2.0


<table>
<thead>
<tr>
<th>
Plugin Name
</th>
<th>
Plugin Description
</th>
</tr>
</thead>
<tbody>
<tr>
<th>
<a href="https://www.javadoc.io/page/com.thoughtworks.deeplearning/plugins-builtins_2.11/latest/com/thoughtworks/deeplearning/plugins/Builtins.html">Builtins</a>
</th>
<td>
All the built-in plugins.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/Atry/1fb0608c655e3233e68b27ba99515f16#file-readme-ipynb">FixedLearningRate</a>
</th>
<td>
Setup fixed learning rate when training INDArray weights.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/Atry/89ee1baa4c161b8ccc1b82cdd9c109fe#file-adagrad-sc">Adagrad</a>
</th>
<td>
An adaptive gradient algorithm with per-parameter learning rate for INDArray weights.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/TerrorJack/8154015cc0ac5cfba8e351b642ef12b3#file-readme-ipynb">L1Regularization</a>
</th>
<td>
L1 Regularization.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/TerrorJack/a60ff752270c40a6485ee787837390aa#file-readme-ipynb">L2Regularization</a>
</th>
<td>
L2 Regularization.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/TerrorJack/08454c71448b626b013ddabd74d06adf#file-readme-ipynb">Momentum</a>
</th>
<td>
The Momentum and NesterovMomentum optimizer for SGD.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/TerrorJack/6b0640c76efc6788f13400ae91849e68#file-readme-ipynb">RMSprop</a>
</th>
<td>
The RMSprop optimizer for SGD.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/TerrorJack/4a4dd1929963a34bf20340022b0f03d3#file-readme-ipynb">Adam</a>
</th>
<td>
The Adam optimizer for SGD.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/TerrorJack/a7af811a0ee592d41ab57f2c5d49f08b#file-readme-ipynb">INDArrayDumping</a>
</th>
<td>
A plugin to dump weight matrices during training.
</td>
</tr>
<tr>
<th>
<a href="https://gist.github.com/TerrorJack/cdd9cc5adc82fc86abf8b4c72cd26e76#file-readme-ipynb">CNN</a>
</th>
<td>
A standalone CNN implementation.
</td>
</tr>
</tbody>
<tfoot>
<tr>
<td colspan="2"><a href="http://deeplearning.thoughtworks.school/get-involved">Add your own algorithms, models or any cool features here.</a></td>
</tr>
</tfoot>
</table>

## Links

* [DeepLearning.scala homepage](http://deeplearning.thoughtworks.school/)
* [DeepLearning.scala on Github](https://github.com/ThoughtWorksInc/DeepLearning.scala/)
* [Getting Started for DeepLearning.scala 2.0](http://deeplearning.thoughtworks.school/demo/GettingStarted.html)
* [API reference documentation](https://javadoc.io/page/com.thoughtworks.deeplearning/deeplearning_2.11/latest/com/thoughtworks/deeplearning/package.html)
