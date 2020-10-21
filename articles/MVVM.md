## MVVM

一个简单的MVVM架构，将业务数据从服务端到渲染到UI之间添加ViewModel和Service层，从而方便数据的处理，并将请求和控件的布局从Controller层、View层中解耦。

### ViewModel

负责接受View层的操作，然后转化成服务端的请求，服务端完成请求之后，根据对应的数据做布局处理。

### Service

服务端，用来抽象进行数据的输入，除了常规的网络请求，还可以是数据库、文件读取等操作，这里以网络请求为例进行讲解。

从服务端获取的数据会被封装到`XXXResultSet`中，`ResultSet`是一个service数据和业务模型之间的转接层，`ViewModel`会根据`ResultSet`中的数据来进一步的进行处理。

### Model

数据指的是从服务端得到的内容，之后会渲染到UI上。数据从Service开始由`json`转化成`id<XXXModelAble>`，然后经过ViewModel转化成`XXXCellLayoutData`，这个`CellLayoutData`除了包含最原始的数据，以及具体要展示内容的位置和大小。

