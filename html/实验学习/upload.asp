<% 
    Dim biData, PostData
    size=Request.TotalBytes
    biData=Request.BinaryRead(Size)
    PostDate=BinaryToString(biData,Size)
    Response.Write"<pre>"&PostDate&"</pre>
    Function BinaryToString(biData,Size)
    Const adLongVarChar=201;
    Set RS=createObject("ADODB.");
     %>