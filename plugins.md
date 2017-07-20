---
layout: markdown
title: Plugins
---

In DeepLearning.scala 2.0, all features are provided by plugins.

A plugin is a Scala `trait` that can be mixed-in with other plugins. Plugins can either provide new features or modify behaviors of existing features.

Here are some examples of what plugins can do:

* An optimization algorithm
* A special subnetwork
* A primary differentiable operator
* Logging
* Integration of other linear algebra libraries

## How to use plugins?

Typically, plugins of a neural network are usually setup as following:

``` scala
import com.thoughtworks.feature.Factory
val hyperparameters = Factory[Plugin1 with Plugin2 with Plugin3].newInstance(
  hyperparameterKey1 = hyperparameterValue1,
  hyperparameterKey2 = hyperparameterValue2,
  hyperparameterKey3 = hyperparameterValue3
)
import hyperparameters.implicits._
```

`hyperparameterKey1`, `hyperparameterKey2` and `hyperparameterKey3` are settings required by `Plugin1`, `Plugin2` and `Plugin3`. Those hyperparameter keys may differ when different plugins are used.

Then, the neural network can be built from functions and types in `hyperparameters`.

``` scala
val weight1 = hyperparameters.INDArrayWeight(initialValue1)
val weight2 = hyperparameters.INDArrayWeight(initialValue2)
val weight3 = hyperparameters.INDArrayWeight(initialValue3)
def myNeuralNetwork(input: INDArray): hyperparameters.INDArrayLayer = {
  val layer1 = hyperparameters.function1(input, weight1)
  val layer2 = layer1.method1(weight2)
  hyperparameters.function2(layer2, weight3)
}
```

`INDArrayLayer` and `INDArrayWeight`, `function1`, `function2` and `method1` are types and functions provided by plugins. Also, those types and functions may differ when different plugins are used.

See [Getting Started](demo/2.0.0-Preview/GettingStarted.html) for a complete example of the usage of plugins.

## Built-in plugins

Every DeepLearning.scala 2.0 built-in plugin is a library distributed on Maven central repository. The artifact ID is the lower cased plugin name with a `plugins-` prefix, and
the group ID is `com.thoughtworks.deeplearning`.

The complete list of all built-in plugins can be found in [Scaladoc of `com.thoughtworks.deeplearning.plugins` package](https://javadoc.io/page/com.thoughtworks.deeplearning/deeplearning_2.11/latest/com/thoughtworks/deeplearning/plugins/package.html).

In most cases, you may want to enable all built-in plugins at once. Then you only need the [Builtins](https://javadoc.io/page/com.thoughtworks.deeplearning/plugins-builtins_2.11/latest/com/thoughtworks/deeplearning/plugins/Builtins.html) plugin, which contains all other built-in plugins.

To install the `Builtins` plugin for a sbt project, you can add the following settings in your `build.sbt`:

``` scala
libraryDependencies += "com.thoughtworks.deeplearning" %% "plugins-builtins" % "latest.release"
```

To install the plugin in [Jupyter Scala](https://github.com/alexarchambault/jupyter-scala) or [Ammonite REPL](http://ammonite.io/), you can use magic imports.

``` scala
import $ivy.`com.thoughtworks.deeplearning::plugins-builtins:2.0.0`
```

Then, in the Scala source file, use the `Builtins` plugin as following:
``` scala
import com.thoughtworks.deeplearning.plugins.Builtins
val hyperparameters = Factory[Builtins].newInstance()
```


## Non-built-in plugins

Most of non-built-in plugins are distributed as source files, as simple as a Gist.

<table>
<thead>
<th>
Plugin Name
</th>
<th>
Plugin Description
</th>
</thead>
<tbody>
<tr>
<th>
[FixedLearningRate](https://gist.github.com/Atry/1fb0608c655e3233e68b27ba99515f16)
</th>
<td>
Setup fixed learning rate when training INDArray weights.
</td>
</tr>
<tr>
<th>
[Adagrad](https://gist.github.com/Atry/89ee1baa4c161b8ccc1b82cdd9c109fe)
</th>
<td>
An adaptive gradient algorithm with per-parameter learning rate for INDArray weights.
</td>
</tr>
</tbody>
<tfoot>
<tr>
<td colspan="2">Add your own algorithms, models or any cool features here.</td>
</tr>
</tfoot>
</table>

See [Contributor Guide](demo/2.0.0-Preview/ContributorGuide.html) for the guideline to build a plugin.
