## WSDL

WSDL是一个用于精确描述Web服务的文档，WSDL文档是一个遵循WSDL-XML模式的XML文档。WSDL 文档将Web服务定义为服务访问点或端口的集合。在 WSDL 中，由于服务访问点和消息的抽象定义已从具体的服务部署或数据格式绑定中分离出来，因此可以对抽象定义进行再次使用。

## 文档结构

WSDL文件基本元素： 

| 元素              | 作用 |
| ----------------- | ---- |
| definitions          | 所有的WSDL文档的根元素均是definitions元素。该元素封装了整个文档，同时通过其name提供了一个WSDL文档。除了提供一个命名空间（targetNamespace）外，该元素没有其他作用。 |
| types（消息类型）    | 数据类型定义的容器，它使用某种类型系统（如 XSD）。           |
| message（消息）      | 通信数据的抽象类型化定义，它由一个或者多个 part 组成。       |
| part（消息参数）     | 消息参数                                                     |
| portType（端口类型） | 特定端口类型的具体协议和数据格式规范。它由一个或者多个 Operation组成。 |
|operation（操作）|对服务所支持的操作进行抽象描述，WSDL定义了四种操作： <br/>1.单向（one-way）：端点接受信息； <br/>3.要求-响应（solicit-response）：端点发送消息，然后接受相关消息;<br />4.通知（notification ）：端点发送消息。|
|import|import元素使得可以在当前的WSDL文档中使用其他WSDL文档中指定的命名空间中的定义元素。通常在用户希望模块化WSDL文档的时候，该功能是非常有效果的。|
|binding|binding元素将一个抽象portType映射到一组具体协议(SOAO和HTTP)、消息传递样式、编码样式。通常binding元素与协议专有的元素和在一起使用。|
