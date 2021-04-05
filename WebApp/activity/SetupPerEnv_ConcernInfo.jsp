<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:include page="/inc/header.jsp" flush="true"/>
</head>
<script language="javascript">
	function fun_addopt(tselect, ntext, nvalue){
        i=tselect.length;
        var noption = new Option(ntext,nvalue);
        tselect.options[i] = noption;
        tselect.options[i].selected = true;
        return;
	}

	function fun_delopt(tselect,itemNo){
        tselect.options[itemNo]=null
        return;
	}

	function fun_toseled(obj){
        if(obj.unseledmn.selectedIndex < 0){
        	alert('[���α׷�]���� �߰��� ���α׷����� �����Ͻʽÿ�');
       		obj.unseledmn.selected = false;
        	return;
        }
        else {
        	j = obj.unseledmn.selectedIndex;
        	fun_addopt(obj.seledmn,obj.unseledmn.options[j].text,obj.unseledmn.options[j].value);
        	fun_delopt(obj.unseledmn, j);
        	obj.unseledmn.selected = false;
        	subSelectIndex = obj.seledmn.selectedIndex;
        }
	}

	function fun_tounseled(obj){
        if(obj.seledmn.selectedIndex < 0){
	        alert('[���ٰ��� ���α׷�]���� ������ ���α׷����� �����Ͻʽÿ�');
    	    obj.seledmn.selected = false;
     	   return;
        }else {
        	j = obj.seledmn.selectedIndex;

       		fun_addopt(obj.unseledmn,obj.seledmn.options[j].text,obj.seledmn.options[j].value);
			fun_delopt(obj.seledmn, j);
       		obj.seledmn.selected = false;
       		subSelectIndex = obj.seledmn.selectedIndex;
        }
	}

	function fun_click(obj) {
        if(obj.seledmn.selectedIndex >= 0)
                subSelectIndex = obj.seledmn.selectedIndex;
	}

	function fun_save(obj) {
		if(obj.seledmn.length < 1){
			obj.app_id.value = "-";
		    obj.submit();
			return
		}
		var varId = "";
		for(var i=0; i<obj.seledmn.length;i++){
			if(i != (obj.seledmn.length - 1)){
				varId = varId + obj.seledmn.options[i].value + ',';
			}else{
				varId = varId + obj.seledmn.options[i].value;
			}
		}
		obj.app_id.value = varId;
		obj.submit();
	}

	function fun_cancel(obj) {

	}

	function fun_up(obj){

		if(obj.seledmn.selectedIndex < 0){
			alert('������ �ٲ� �޴��� �����Ͻʽÿ�');
			obj.seledmn.selected = false;
			return;
		}

		var tmpValue1,tmpValue2;

		if (subSelectIndex > 0) {
			<!-- alert(subSelectIndex);   //-->
			tmpValue1 = obj.seledmn[subSelectIndex -1].value;
			tmpValue2 = obj.seledmn[subSelectIndex -1].text;
			obj.seledmn[subSelectIndex-1].value = obj.seledmn[subSelectIndex].value;
			obj.seledmn[subSelectIndex-1].text =  obj.seledmn[subSelectIndex].text;
			obj.seledmn[subSelectIndex].value = tmpValue1;
			obj.seledmn[subSelectIndex].text = tmpValue2;
			obj.seledmn.selectedIndex = subSelectIndex-1;
			subSelectIndex --;
		}else if(subSelectIndex == 0){
			alert('�̵��� ���Դϴ�.');
		}
	}

	function fun_down(obj){

		if(obj.seledmn.selectedIndex < 0){
			alert('������ �ٲ� �޴��� �����Ͻʽÿ�');
			obj.seledmn.selected = false;
			return;
		}

		var tmpValue1,tmpValue2;
		if (subSelectIndex < (obj.seledmn.length - 1)  && subSelectIndex != -1)         {
			<!--alert(obj.seledmn.length + " : " + subSelectIndex);  //-->
			tmpValue1 = obj.seledmn[subSelectIndex +1].value;
			tmpValue2 = obj.seledmn[subSelectIndex +1].text;
			obj.seledmn[subSelectIndex+1].value = obj.seledmn[subSelectIndex].value;
			obj.seledmn[subSelectIndex+1].text = obj.seledmn[subSelectIndex].text;
			obj.seledmn[subSelectIndex].value = tmpValue1;
			obj.seledmn[subSelectIndex].text = tmpValue2;
			obj.seledmn.selectedIndex = subSelectIndex+1;
			subSelectIndex ++;
		}else if( subSelectIndex == obj.seledmn.length - 1 ){
			alert('�̵��� ���Դϴ�.');
		}
	}

	function fun_cancel(){
		location.href="/activity/SetupPerEnv_ConcernInfo.jsp";
	}
</script>
<body>
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="useritet/SelectConcernInfoProc.jsp" %>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu01.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu01.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="form_main" method="post" action="./useritet/InsertConcernInfoProc.jsp" >
<input type="hidden" name="app_id" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
        <h3>����ȯ�漳�� <span class="sub_stl" >- ������������</span> </h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > ���������� > ����ȯ�漳 &gt; ������������</div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->
      <div class="myP">
        <!-- list -->
        <span class="list02_tl"> ������������ </span>
        <table width="720" height="220" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="85">&nbsp;</td>
            <td width="128">
			  <table height="225" border="0" cellpadding="3" cellspacing="5"  style=" background: #A5C45B">
              <tr>
                <th width="45%" height="12" style="color: #fff;">���� ����������</th>
              </tr>
              <tr>
                <td height="13" class="t_right"><select size="20" name="unseledmn" style="width:250px; height:190px; border:#FFF solid 1px">
<%
			for(int m=0; m<objItetIngPrgId.size(); m++){
                String name = (String)objItetIngPrgNm.elementAt(m);
                if (!name.equals("���ñ��������Ʈ")&&!name.equals("���� ��������")&&!name.equals("���� �����Խ���")&&!name.equals("�����Խ���")&&!name.equals("����ȸȨ������")){
%>
                  <OPTION value="<%=(String)objItetIngPrgId.elementAt(m)%>"><%=(String)objItetIngPrgNm.elementAt(m)%></OPTION>
<%
                }
            }
%>

                </select></td>
              </tr>
            </table></td>
            <td width="80" align="center"><a href="javascript:fun_toseled(document.form_main)"><img src="../images2/btn/bt_plus.gif" width="47" height="17" /></a><br />
            <br />
            <a href="javascript:fun_tounseled(document.form_main)"><img src="../images2/btn/bt_del.gif" width="47" height="17" /></a></td>
            <td width="248">
			<table height="225" border="0" cellpadding="3" cellspacing="5"  style=" background: #53C0C4">
              <tr>
                <th width="45%" height="12" style="color: #fff;">������ ��������</th>
              </tr>
              <tr>
                <td height="13" class="t_right">
				<select onclick="fun_click(document.form_main)" onchange="fun_click(document.form_main)" size="20" name="seledmn" style="width:250px; height:190px; border:#FFF solid 1px">
<%
			for(int n=0; n<objItetEdPrgId.size(); n++){
                String name = (String)objItetEdPrgNm.elementAt(n);
                if (!name.equals("���ñ��������Ʈ")&&!name.equals("���� ��������")&&!name.equals("���� �����Խ���")&&!name.equals("�����Խ���")&&!name.equals("����ȸȨ������")){
%>
                  <option value="<%=(String)objItetEdPrgId.elementAt(n)%>"><%=(String)objItetEdPrgNm.elementAt(n)%></OPTION>
<%
                }
			}
%>
                </select></td>
              </tr>
            </table></td>
            <td align="center"><a href="javascript:fun_up(document.form_main)"><img src="../images2/btn/bt_up.gif" width="17" height="15" /></a><br />
            <br />
            <a href="javascript:fun_down(document.form_main)"><img src="../images2/btn/bt_down.gif" width="17" height="15" /></a></td>
          </tr>
        </table>
        <!-- /list -->
        <!-- ����Ʈ ��ư-->
        <div id="btn_all" class="t_right" > <span class="list_bt"><a href="javascript:fun_save(document.form_main)">�� ��</a></span><span class="list_bt"><a href="javascript:fun_cancel()">�� ��</a></span></div>
        <!-- /����Ʈ ��ư-->
        <!-- /�������� ���� -->
      </div>
    </div>
	</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>