





user_sid : 0000000000000001






<HTML>
<HEAD>
<link rel="stylesheet" href="/jsp/admin/css/global2.css" type="text/css">
<script src="/js/usersys/common/AnyDMS.js"></script>
<script src="/js/adminsys/common/adminFunction.js"></script>
<script src="/js/adminsys/folder/folderFunction.js"></script>

<script language="javascript">
	
	function editCheck() {
		var f = document.frmFolder;
		if (f.code.value.length == 0) {
			alert("CODE�� �Է��� �ּ���");
			f.code.focus();
			return;
		} else if (f.name.value.length == 0) {
			alert("�̸��� �Է��� �ּ���");
			f.name.focus();
			return;
		}
		
		if (f.nimiral.value == "all") {
			if (f.comments_kr_tmp.value.length == 0 || f.comments_eng_tmp.value.length == 0) {
				alert("�󼼼����� �Է��� �ּ���");
				return;
			}
		} else if (f.nimiral.value == "kor" && f.comments_kr_tmp.value.length == 0) {
			alert("�ѱ� �󼼼����� �Է��� �ּ���");
			f.comments_kr_tmp.focus();
			return;
		} else if (f.nimiral.value == "eng" && f.comments_eng_tmp.value.length == 0) {
			alert("���� �󼼼����� �Է��� �ּ���");
			f.comments_eng_tmp.focus();
			return;
		}
		
		if (f.nimiral.value == "all") {
			alert(f.comments_kr_tmp.value);
			var str1 = f.comments_kr_tmp.value;
			var str2 = f.comments_eng_tmp.value;
			alert(str1);
			f.comments_kr.value = str1;
			f.comments_eng.value = str2;
			alert(f.comments_kr.value);
		}
		/*else if (f.nimiral.value == "kor") {
			f.comments_kr.value = f.comments_kr_tmp.value;
			f.comments_eng_tmp.value = "";
			f.comments_eng.value = "";
		} else if (f.nimiral.value == "eng") {
			f.comments_kr_tmp.value = "";
			f.comments_kr.value = "";
			f.comments_eng.value = f.comments_eng_tmp.value;
		}
		*/
		
		//f.action = "/include/folder/_renameFolder.jsp";
		f.action = "s_error_action.jsp";
		//f.submit();
		if (confirm("���� �Ͻðڽ��ϱ�?")) {
			f.submit();
		}
	}
	
	function selectSite(str) {
		if (str == "kor") {
			document.frmFolder.comments_eng_tmp.value = "";
			document.frmFolder.comments_eng_tmp.style.background="#e1e1e1";
			document.frmFolder.comments_kr_tmp.style.background="#ffffff";
			document.frmFolder.comments_kr_tmp.value = "OfficeServ ��ǰ�� ���� ��ȭ��ȣ�� �ɷ����� ��ȭ��ȣ�� ȸ��, ����, ȣ�� ��  ����� ���ο��� �ο��� ���� ���� ��ȣ�� ��ȯ�� �ִ� ��ġ�Դϴ�. �ý��ۿ� ����� �߰�� �� ���� ��ȭ�⿡�� �̵����� ���, ���� ���, ��ȭ ���� ���, ��ȭ ��� ��� �� ���� ���� ��ȭ ���� ����� �����Ͽ� Ȱ���� �� �ֽ��ϴ�.";
			document.frmFolder.comments_eng_tmp.disabled=true;
			document.frmFolder.comments_kr_tmp.disabled= false;
		} else if (str == "eng") {
			document.frmFolder.comments_kr_tmp.value = "";
			document.frmFolder.comments_kr_tmp.style.background="#e1e1e1";
			document.frmFolder.comments_eng_tmp.style.background="#ffffff";
			document.frmFolder.comments_eng_tmp.value = "OfficeServ product from Samsung Electronics is an integrated communications solution that converges voice and data communications to provide medium and large sized organization the power to handle any task and accommodate future growth.";
			document.frmFolder.comments_kr_tmp.disabled=true;
			document.frmFolder.comments_eng_tmp.disabled=false;
		} else if (str == "all") {
			document.frmFolder.comments_eng_tmp.style.background="#ffffff";
			document.frmFolder.comments_kr_tmp.style.background="#ffffff";
			document.frmFolder.comments_eng_tmp.disabled= false;
			document.frmFolder.comments_kr_tmp.disabled= false;
			document.frmFolder.comments_kr_tmp.value = "OfficeServ ��ǰ�� ���� ��ȭ��ȣ�� �ɷ����� ��ȭ��ȣ�� ȸ��, ����, ȣ�� ��  ����� ���ο��� �ο��� ���� ���� ��ȣ�� ��ȯ�� �ִ� ��ġ�Դϴ�. �ý��ۿ� ����� �߰�� �� ���� ��ȭ�⿡�� �̵����� ���, ���� ���, ��ȭ ���� ���, ��ȭ ��� ��� �� ���� ���� ��ȭ ���� ����� �����Ͽ� Ȱ���� �� �ֽ��ϴ�.";
			document.frmFolder.comments_eng_tmp.value = "OfficeServ product from Samsung Electronics is an integrated communications solution that converges voice and data communications to provide medium and large sized organization the power to handle any task and accommodate future growth.";
		}
		
	}
</script>

</HEAD>

<BODY bgcolor="#eeeeee" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<CENTER>
<form name="frmFolder" method="post" action="">
<table cellspacing="0" cellpadding="0" width="380">
	<tr height="35">
		<td colspan="2" class="text_blue"><b>[ī�װ� ������� ����]</b></font></td>
	</tr>	
	<tr>
		<td colspan="2" width="380" height="3" class="top-dark"></td>
	</tr>
	<tr height="25">
  		<td class="top" align="right" width="100">�� ��&nbsp;&nbsp;</td>
		<td width="280">&nbsp;&nbsp;<input type="text" id="code" name="code" size="10" maxlength="10" class="input" value="OFF">
		</td>
	</tr>	  
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>	    
	<tr height="25">
  		<td class="top" align="right" width="100">�� ��&nbsp;&nbsp;</td>
  		<td align="left">&nbsp;&nbsp;<input type="text" id="name" name="name" size="35" class="input" value="OfficeServ">
		</td>
	</tr>
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>	    
	<tr height="25">
  		<td class="top" align="right" width="100">���� ����Ʈ&nbsp;&nbsp;</td>
  		<td align="left">&nbsp;&nbsp;<select name="nimiral" onChange="javascript:selectSite(this.value)">
  				
	  				<option value="all" selected>��ü ����Ʈ</option>
  					<option value="kor">�ѱ� ����Ʈ</option>
  					<option value="eng">���� ����Ʈ</option>
  				
  			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>
	<tr height="25">
  		<td  class="top" align="right" width="100">����(�ѱ�)&nbsp;&nbsp;</td>
		<td style="padding-top:3px;padding-bottom:3px">&nbsp;
			
				<textarea cols="40" rows="7" id="comments_kr_tmp" name="comments_kr_tmp">OfficeServ ��ǰ�� ���� ��ȭ��ȣ�� �ɷ����� ��ȭ��ȣ�� ȸ��, ����, ȣ�� ��  ����� ���ο��� �ο��� ���� ���� ��ȣ�� ��ȯ�� �ִ� ��ġ�Դϴ�. �ý��ۿ� ����� �߰�� �� ���� ��ȭ�⿡�� �̵����� ���, ���� ���, ��ȭ ���� ���, ��ȭ ��� ��� �� ���� ���� ��ȭ ���� ����� �����Ͽ� Ȱ���� �� �ֽ��ϴ�.
			
		</textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>	    
	<tr height="25">
  		<td  class="top" align="right" width="100">����(����)&nbsp;&nbsp;</td>
		<td style="padding-top:3px;padding-bottom:3px">&nbsp;
			
				<textarea cols="40" rows="7" id="comments_eng_tmp" name="comments_eng_tmp">OfficeServ product from Samsung Electronics is an integrated communications solution that converges voice and data communications to provide medium and large sized organization the power to handle any task and accommodate future growth.
			
			</textarea>
		</td>
	</tr>		
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>	    	  	  	
	<tr>
		<td colspan="2" align="right" valign="bottom" height="30">
			<button id="btnConfirm" onClick="javascript:editCheck()">���� Ȯ��</button> &nbsp; 
			<button id="btnCancel" onClick="cancelFolder('iframeFolder')">�� ��</button> 
			
			<!--img id="btnConfirm" border="0" src="/img/basic/warning_confirm_but.gif" 
	      	onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btnConfirm','','/img/basic/warning_confirm_over.gif',1)"
	      	onClick="frmFolder.submit();">	      	
		  	<img id="btnCancel" border="0" src="/img/basic/warning_cancel_but.gif" 
	      	onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('btnCancel','','/img/basic/warning_cancel_over.gif',1)"
		  	onClick="cancelFolder('iframeFolder')" -->&nbsp;
		 </td>
	</tr>	
	
</table>
</CENTER>
<input type="hidden" name="coll_id" value="0402041748500294">
<input type="hidden" name="form_id" value="0000000000002002">
<input type="hidden" id="comments_kr" name="comments_kr" value="">
<input type="hidden" id="comments_eng" name="comments_eng" value="">
</form>
</BODY>
</HTML>


