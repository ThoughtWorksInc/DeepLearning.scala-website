---
title: DeepLearning.scala 2.0.0发布
featured: images/pic01.jpg
layout: post
---

今天，我们很荣幸宣布，DeepLearning.scala 2.0.0发布了。这是DeepLearning.scala的最新稳定版本，不兼容1.x版本。

DeepLearning.scala是个简单的框架，能以面向对象和函数式编程范式组建复杂的神经网络。

* DeepLearning.scala运行在JVM上。既可以用于单独的JVM应用和服务，也能运行在Jupyter Notebook里。
* DeepLearning.scala建模能力强。各种类型的神经网络都可以通过`map`、`reduce`等高阶函数组装出来。
* DeepLearning.scala支持插件。你能找到各种插件，提供各种算法、模型、超参数等等。
* 以上所有功能都支持静态类型检查。

## DeepLearning.scala 2.0的特性

### 动态神经网络

与其他一些深度学习框架不同，DeepLearning.scala中的神经网络结构会在运行时才动态确定。我们的神经网络都是程序。一切Scala特性，包括函数和控制结构，都能直接在神经网络中使用。

比如：

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

以上神经网络会根据`ordinaryScalaFunction`的返回值进入不同的子网络，而`ordinaryScalaFunction`只是个普通的Scala函数。


有了动态创建神经网络的能力，一名普通的程序员，就能够用很简单的代码构建复杂神经网络。你还是像以前一样编写程序，唯一的区别是，DeepLearning.scala里写的程序有学习能力，能够持续根据反馈修改自身参数。

### 函数式编程

DeepLearning.scala 2.0基于Monads，所以可以任意组合。即使是很复杂的网络也可以从基本操作组合出来。除了Monad以外，我们还提供了Applicative类型类（type class），能并行执行多处耗时计算。

比如，先前的例子可以用高阶函数风格写成这样：

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

DeepLearning.scala 2.0的核心概念是[DeepLearning](https://javadoc.io/page/com.thoughtworks.deeplearning/deeplearning_2.11/latest/com/thoughtworks/deeplearning/DeepLearning.html)依赖类型类（dependent type class），可以见证（witness）可微分表达式。换句话说，对于任何数据类型，包括你定制的类型，只要提供了对应的`DeepLearning`类型类的实例，就能具备深度学习能力，成为深度神经网络的一部分。

### 面向对象编程

DeepLearning 2.0的代码结构利用了依赖对象类型演算（Dependent Object Type calculus，DOT），所有特性都通过支持混入（mixin）的插件来实现。插件能修改一切DeepLearning.scala类型的API和行为。

这种架构不光解决了[expression problem](https://en.wikipedia.org/wiki/Expression_problem)，还让每个插件都可以“虚依赖”其他插件。

比如，插件作者编写优化器[Adagrad](https://gist.github.com/Atry/89ee1baa4c161b8ccc1b82cdd9c109fe#file-adagrad-sc)插件时，无需显式调用learning rate相关的函数。只要插件用户同时启用了`Adagrad`和[FixedLearningRate](https://gist.github.com/Atry/1fb0608c655e3233e68b27ba99515f16#file-readme-ipynb)两个插件，那么最终的`Adagrad`执行优化时就会自动调用`FixedLearningRate`中的计算。

## DeepLearning.scala 2.0的插件

<table>
<thead>
<tr>
<th>
插件名称
</th>
<th>
插件描述
</th>
</tr>
</thead>
<tbody>
<tr>
<th>
<a href="https://www.javadoc.io/page/com.thoughtworks.deeplearning/plugins-builtins_2.11/latest/com/thoughtworks/deeplearning/plugins/Builtins.html">Builtins</a>
</th>
<td>
所有的内置插件
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
<td colspan="2"><a href="http://deeplearning.thoughtworks.school/get-involved">贡献你自己的算法、模型或者任何炫酷的功能</a></td>
</tr>
</tfoot>
</table>

## 相关链接

* [DeepLearning.scala主页](http://deeplearning.thoughtworks.school/)
* [DeepLearning.scala Github页面](https://github.com/ThoughtWorksInc/DeepLearning.scala/)
* [DeepLearning.scala 2.0快速上手指南](http://deeplearning.thoughtworks.school/demo/GettingStarted.html)
* [API参考文档](https://javadoc.io/page/com.thoughtworks.deeplearning/deeplearning_2.11/latest/com/thoughtworks/deeplearning/package.html)
