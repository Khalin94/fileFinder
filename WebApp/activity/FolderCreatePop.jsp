<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script src='/js/forum.js'></script>
<script language="javascript">
  function fun_submit(){
    if(checkStrLen(form_main.docbox_nm, 50, "������") == false){
            form_main.docbox_nm.focus();
            return;
    } 
    form_main.submit();
  }
</script>
</head>

<body>
<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="./businfo/FolderCreateSub.jsp" %>
<div class="popup">
    <p>��������</p>
<form name="form_main" method="post" action="./businfo/FolderCreatePopProc.jsp">
<input type="hidden" name="organ_id"  value="<%=strOrganId%>">
<input type="hidden" name="top_docbox_id"  value="<%=strDocboxId%>">


       <table border="0" cellspacing="0" cellpadding="0"  class="list02">

            <tr>
                <th height="25">&bull;&nbsp;������ </th>
                <td height="25"><input name="docbox_nm" type="text" ></td>
            </tr>
        </table>
        
        <!-- /list --> 

    <p style= "height:2px;padding:0;"></p>
    <!-- ����Ʈ ��ư-->
    <div id="btn_all" class="t_right">
		<span class="list_bt"><a href="javascript:fun_submit()">����</a></span>&nbsp;&nbsp;
		<span class="list_bt"><a href="javascript:self.close()">���</a></span>&nbsp;&nbsp;
	</div>
    <!-- /����Ʈ ��ư--> 
</div>
</form>
</body>
</html>