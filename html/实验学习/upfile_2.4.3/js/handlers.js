/* Demo Note:  This demo uses a FileProgress class that handles the UI for displaying the file name and percent complete.
The FileProgress class is not part of SWFUpload.
*/


/* **********************
   Event Handlers
   These are my custom event handlers to make my
   web application behave the way I went when SWFUpload
   completes different tasks.  These aren't part of the SWFUpload
   package.  They are part of my application.  Without these none
   of the actions SWFUpload makes will show up in my application.
   ********************** */
function fileQueued(file) {
	try {
		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setStatus("等待上传...");
		progress.toggleCancel(true, this);

	} catch (ex) {
		this.debug(ex);
	}

}

function fileQueueError(file, errorCode, message) {
	try {
		if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
			alert("对不起，每次最多允许选择"+message+"个文件");
			return;
		}

		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
			progress.setStatus("文件太大.");
			this.debug("Error Code: File too big, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
			progress.setStatus("不允许上传0字节的文件.");
			this.debug("Error Code: Zero byte file, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
			progress.setStatus("未知文件类型.");
			this.debug("Error Code: Invalid File Type, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		default:
			if (file !== null) {
				progress.setStatus("未知错误！");
			}
			this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		}
	} catch (ex) {
        this.debug(ex);
    }
}

function fileDialogComplete(numFilesSelected, numFilesQueued) {
	try {
		if (numFilesSelected > 0) {
			document.getElementById('btnUpload').disabled = false;
			document.getElementById(this.customSettings.cancelButtonId).disabled = false;
		}

		/* I want auto start the upload and I can do that here */
		//this.startUpload();
	} catch (ex)  {
        this.debug(ex);
	}
}

function uploadStart(file) {
	try {
		/* I don't want to do any file validation or anything,  I'll just update the UI and
		return true to indicate that the upload should start.
		It's important to update the UI here because in Linux no uploadProgress events are called. The best
		we can do is say we are uploading.
		 */
		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setStatus("上传中...");
		progress.toggleCancel(true, this);
	}
	catch (ex) {}

	return true;
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
	try {
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);

		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setProgress(percent);
		progress.setStatus("上传中...");
	} catch (ex) {
		this.debug(ex);
	}
}
function SetCopy(obj)
{
   var str=obj.parent().prev().eq(0).children().attr("href");
   if (document.all){                                            //判断Ie
	   window.clipboardData.setData('text', str);
	   alert("复制成功，立即开始吧！");
	   }else{
	   alert("您的浏览器不支持剪贴板操作，请自行复制。"); 
	     }
}
function uploadSuccess(file, serverData) {
	try {
		
		 var obj=window.location;
		 var url="http://";
		 var path=obj.pathname;
		 path=path.substring(path.indexOf("/"),path.lastIndexOf("/"));
		 if(obj.protocol.indexOf("http:")!=-1||obj.protocol.indexOf("https:")!=-1)
	     {
			 url=obj.protocol+"//";
	     }
		 url+=obj.host;
		 if(path!="")
	     {
			 url+=path;
	     }
		//if (serverData.substring(1, 5) === "suc:") {
		if (serverData.indexOf("suc")!=-1) {
			serverData=serverData.replace(/^(\s*)|(\s*)$/g,'');
			var fileinfo = serverData.replace(/suc:/g,'').split(",");
			//var fileinfo =serverData.substring(4).split(",");
			//alert(fileinfo[0].length+"|"+fileinfo);
			var progress = new FileProgress(file, this.customSettings.progressTarget);
			progress.setComplete();
			progress.setText("<a href=\""+url+"/"+fileinfo[0]+fileinfo[1]+"\" target=\"_blank\">"+fileinfo[1]+"</a>");
			var status = "恭喜你，文件上传成功！ <br />";
			status += "大小："+parseFloat(parseInt(fileinfo[2])/1024).toFixed(2)+ "K&nbsp;&nbsp;&nbsp;<a href=\"#\" onclick=\"SetCopy($(this))\" >复制</a> <br />";
			status += "地址："+url+"/"+fileinfo[0]+fileinfo[1];  //这里需要自己根据自己网站实际情况做下修改
			progress.setStatus(status);
			progress.toggleCancel(false);
			document.getElementById('imglist').innerHTML += "[img]"+url+"/"+fileinfo[0]+fileinfo[1]+'[/img]<br/>';
			getimgtip();
		}else{
			var progress = new FileProgress(file, this.customSettings.progressTarget);
			progress.setError();
			progress.setStatus("上传失败："+serverData.substring(5));
			progress.toggleCancel(false);
		}

	} catch (ex) {
		this.debug(ex);
	}
}

function uploadError(file, errorCode, message) {
	try {
		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
			progress.setStatus("文件上传失败: " + message);
			this.debug("Error Code: HTTP Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
			progress.setStatus("文件上传失败");
			this.debug("Error Code: Upload Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.IO_ERROR:
			progress.setStatus("服务器IO错误");
			this.debug("Error Code: IO Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
			progress.setStatus("安全错误");
			this.debug("Error Code: Security Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
			progress.setStatus("文件大小超过限制");
			this.debug("Error Code: Upload Limit Exceeded, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
			progress.setStatus("验证失败，上传已被跳过");
			this.debug("Error Code: File Validation Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
			// If there aren't any files left (they were all cancelled) disable the cancel button
			if (this.getStats().files_queued === 0) {
				document.getElementById('btnUpload').disabled = true;
				document.getElementById(this.customSettings.cancelButtonId).disabled = true;
			}
			progress.setStatus("已取消上传");
			progress.setCancelled();
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
			progress.setStatus("已停止上传");
			break;
		default:
			progress.setStatus("未知错误: " + errorCode);
			this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		}
	} catch (ex) {
        this.debug(ex);
    }
}

function uploadComplete(file) {
	if (this.getStats().files_queued === 0) {
		document.getElementById('btnUpload').disabled = true;
		document.getElementById(this.customSettings.cancelButtonId).disabled = true;
	}
}

// This event comes from the Queue Plugin
function queueComplete(numFilesUploaded) {
	var status = document.getElementById("divStatus");
	status.innerHTML = numFilesUploaded + " 个文件被上传.";
}

function AddonloadEvent(func)
{
  var oldonload=window.onload;
  if(typeof oldonload!='function')
  {
       window.onload=func;
  }
  else
  {
      window.onload=function(){
        oldonload();
        func();
      };
  } 
}
function AddEvent(el, type, fn){
	el.addEventListener ? el.addEventListener(type, fn, false) : el.attachEvent('on' + type, fn);
}
function DelEvent(el, type, fn){
	el.removeEventListener ? el.removeEventListener(type, fn, false) : el.detachEvent('on' + type, fn);
}
/*
 * 
 * 
 * www.qhjsw.net
   qhjsw@qhjsw.net
   QQ:909507090
       敬请注意：本程序为开源程序，你可以使用本程序在任何的商业、非商业项目或者网站中。但请你务必保留代码中相关信息（页面logo和页面上必要的链接可以清除），
	 请为本论坛（www.qhjsw.net）加上网址链接，谢谢支持。作为开发者你可以对相应的后台功能进行扩展（增删改相应代码）,但请保留代码中相关来源信息（例如：本论坛网址，邮箱等）。
          如果你进行了修改请务必把修改过的程序以邮件形式发送给本人（qhjsw#qhjsw.net #号换为@）。谢谢合作！
 * 
 */