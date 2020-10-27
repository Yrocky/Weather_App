## MVVM

一个简单的MVVM架构，将业务数据从服务端到渲染到UI之间添加ViewModel和Service层，从而方便数据的处理，并将请求和控件的布局从Controller层、View层中解耦。

### ViewModel

负责接受View层的操作，然后转化成服务端的请求，服务端完成请求之后，根据对应的数据做布局处理。

对于一个列表界面，常用的网络请求也就两种：`reloadData`、`loadMoreData`，ViewModel抽象出来对应的接口，内部通过Service来完成对应的耗时异步操作，同时，所有针对Service返回数据的操作：增、删、改等，也都在ViewModel中

### Service

服务端，用来抽象进行数据的输入，除了常规的网络请求，还可以是数据库、文件读取等操作，这里以网络请求为例进行讲解。

抽象出来`Service层`主要是为了兼容不同异步操作，比如各个项目的网络层会有所不同，使用统一的Service层不仅可以兼容各种网络层，还可以起到很好的规范约束作用。

从服务端获取的数据会被封装到`XXXResultSet`中，`ResultSet`是一个service数据和业务模型之间的转接层，`ViewModel`会根据`ResultSet`中的数据来进一步的进行处理。

### Model

数据，指的是从服务端得到的内容，之后会被渲染到UI上。数据从Service开始由`json`转化成`id<XXXModelAble>`，然后通过`ViewModel`，根据业务方转化成对应的`XXXCellLayoutData`，这个`CellLayoutData`除了包含最原始的数据，还有具体要展示内容的位置和大小等信息。

`CellLayoutData`不仅可以为cell提供布局样式，还可以提供从model解析出来直接供cell展示使用的数据，从这一点上来看，它就是cell的viewModel。


### Usage

在具体使用中，创建XXXViewModel的子类、XXXService的子类、XXXCellLayoutData的子类，在对应的类中根据前面描述的功能添加对应的逻辑代码即可。


