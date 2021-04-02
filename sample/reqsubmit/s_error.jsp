





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
			alert("CODE를 입력해 주세요");
			f.code.focus();
			return;
		} else if (f.name.value.length == 0) {
			alert("이름을 입력해 주세요");
			f.name.focus();
			return;
		}
		
		if (f.nimiral.value == "all") {
			if (f.comments_kr_tmp.value.length == 0 || f.comments_eng_tmp.value.length == 0) {
				alert("상세설명을 입력해 주세요");
				return;
			}
		} else if (f.nimiral.value == "kor" && f.comments_kr_tmp.value.length == 0) {
			alert("한글 상세설명을 입력해 주세요");
			f.comments_kr_tmp.focus();
			return;
		} else if (f.nimiral.value == "eng" && f.comments_eng_tmp.value.length == 0) {
			alert("영문 상세설명을 입력해 주세요");
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
		if (confirm("수정 하시겠습니까?")) {
			f.submit();
		}
	}
	
	function selectSite(str) {
		if (str == "kor") {
			document.frmFolder.comments_eng_tmp.value = "";
			document.frmFolder.comments_eng_tmp.style.background="#e1e1e1";
			document.frmFolder.comments_kr_tmp.style.background="#ffffff";
			document.frmFolder.comments_kr_tmp.value = "OfficeServ 제품은 국선 전화번호로 걸려오는 통화신호를 회사, 주택, 호텔 등  사업장 내부에서 부여한 고유 내선 번호로 전환해 주는 장치입니다. 시스템에 연결된 중계대 및 각종 전화기에서 이동착신 기능, 응답 기능, 통화 제어 기능, 전화 대기 기능 등 각종 편리한 전화 서비스 기능을 셋팅하여 활용할 수 있습니다.";
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
			document.frmFolder.comments_kr_tmp.value = "OfficeServ 제품은 국선 전화번호로 걸려오는 통화신호를 회사, 주택, 호텔 등  사업장 내부에서 부여한 고유 내선 번호로 전환해 주는 장치입니다. 시스템에 연결된 중계대 및 각종 전화기에서 이동착신 기능, 응답 기능, 통화 제어 기능, 전화 대기 기능 등 각종 편리한 전화 서비스 기능을 셋팅하여 활용할 수 있습니다.";
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
		<td colspan="2" class="text_blue"><b>[카테고리 등록정보 수정]</b></font></td>
	</tr>	
	<tr>
		<td colspan="2" width="380" height="3" class="top-dark"></td>
	</tr>
	<tr height="25">
  		<td class="top" align="right" width="100">코 드&nbsp;&nbsp;</td>
		<td width="280">&nbsp;&nbsp;<input type="text" id="code" name="code" size="10" maxlength="10" class="input" value="OFF">
		</td>
	</tr>	  
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>	    
	<tr height="25">
  		<td class="top" align="right" width="100">이 름&nbsp;&nbsp;</td>
  		<td align="left">&nbsp;&nbsp;<input type="text" id="name" name="name" size="35" class="input" value="OfficeServ">
		</td>
	</tr>
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>	    
	<tr height="25">
  		<td class="top" align="right" width="100">적용 사이트&nbsp;&nbsp;</td>
  		<td align="left">&nbsp;&nbsp;<select name="nimiral" onChange="javascript:selectSite(this.value)">
  				
	  				<option value="all" selected>전체 사이트</option>
  					<option value="kor">한글 사이트</option>
  					<option value="eng">영문 사이트</option>
  				
  			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>
	<tr height="25">
  		<td  class="top" align="right" width="100">설명(한글)&nbsp;&nbsp;</td>
		<td style="padding-top:3px;padding-bottom:3px">&nbsp;
			
				<textarea cols="40" rows="7" id="comments_kr_tmp" name="comments_kr_tmp">OfficeServ 제품은 국선 전화번호로 걸려오는 통화신호를 회사, 주택, 호텔 등  사업장 내부에서 부여한 고유 내선 번호로 전환해 주는 장치입니다. 시스템에 연결된 중계대 및 각종 전화기에서 이동착신 기능, 응답 기능, 통화 제어 기능, 전화 대기 기능 등 각종 편리한 전화 서비스 기능을 셋팅하여 활용할 수 있습니다.
			
		</textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2" width="380" height="1" class="normal"></td>
	</tr>	    
	<tr height="25">
  		<td  class="top" align="right" width="100">설명(영문)&nbsp;&nbsp;</td>
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
			<button id="btnConfirm" onClick="javascript:editCheck()">수정 확인</button> &nbsp; 
			<button id="btnCancel" onClick="cancelFolder('iframeFolder')">취 소</button> 
			
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


