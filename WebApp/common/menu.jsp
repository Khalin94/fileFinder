<%
	String menu = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("menu"));
	String memType = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("memType"));
	
	if ("".equalsIgnoreCase(menu) || menu == null || menu.length() == 0) menu = "1";
	if ("".equalsIgnoreCase(memType) || memType == null || memType.length() == 0) memType = "1";
%>

<table border="0" cellpadding="0" cellspacing="0" width="190">
	<tr>
		<td width="190" align="center">
			<table border="0" cellspacing="0" cellpadding="0" border="1px solid #c0c0c0;">
				
				<!-- ù��° �޴�. �ǿ��� �ڷ� �䱸 -->
				<% if ("1".equalsIgnoreCase(menu)) { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;<B>�� �ǿ��� �ڷ� �䱸</B></td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;�� �䱸�� �ۼ�</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;�� �䱸�� ��ȸ</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- �ۼ� �� �䱸��</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- �߼� �Ϸ� �䱸��</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- ���� �Ϸ� �䱸��</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- ����ȸ ���� ��û��</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;�� �䱸 ��� ��ȸ</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- ���� �Ϸ� �䱸 ���</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- ������ �䱸 ���</td>
				</tr>
				<% } else { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;�� �ǿ��� �ڷ� �䱸</td>
				</tr>
				<tr>
					<td height="1" class="c1"></td>
				</tr>
				<% } %>
					
				<% if ("2".equalsIgnoreCase(menu)) { %>
				<!-- �ι�° �޴�. ����ȸ �ڷ� �䱸 -->
				<tr>
					<td width="190" height="23" class="e1">&nbsp;<B>�� ����ȸ �ڷ� �䱸</B></td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;�� �䱸�� �ۼ�</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;�� �䱸�� ��ȸ</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- �ۼ� �� �䱸��</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- ���� �Ϸ� �䱸��</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- �߼� �Ϸ� �䱸��</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- ���� �Ϸ� �䱸��</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;�� �䱸 ��� ��ȸ</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- ���� �Ϸ� �䱸 ���</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- ������ �䱸 ���</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;�� ���� �ڷ���</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- �ڷ��� �ۼ�</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- �ڷ��� ��ȸ</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- �ڷ� ��� ��ȸ</td>
				</tr>
				<% } else { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;�� ����ȸ �ڷ� �䱸</td>
				</tr>
				<tr>
					<td height="1" class="c1"></td>
				</tr>
				<% } %>


				<!-- ����° �޴�. ���� �ڷ� ��� -->
				<tr>
					<td width="190" height="23" class="e1">&nbsp;�� ���� �ڷ� ���</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>

				<!-- �׹�° �޴�. ���� ���� �ڷ��� -->
				<tr>
					<td width="190" height="23" class="e1">&nbsp;�� ���� ���� �ڷ���</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>

				<!-- �ټ���° �޴�. ����ȸ ���� -->
				<% if ("2".equalsIgnoreCase(memType)) { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;�� ����ȸ ����</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>
				<% } %>

				<!-- ������° �޴�. ��ȸ�ǿ� �� ���� ��ȸ -->
				<% if ("2".equalsIgnoreCase(memType)) { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;�� ��ȸ�ǿ� �� ���� ��ȸ</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>
				<% } %>

				<!-- �ϰ���° �޴�. ��� ����� ��ȸ -->
				<% if ("1".equalsIgnoreCase(memType)) { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;�� ��� ����� ��ȸ</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>
				<% } %>

				<!-- ������° �޴�. ���δ� �䱸 ��� -->
				<tr>
					<td width="190" height="23" class="e1">&nbsp;�� ���δ� �䱸 ���</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>
			</table>
		</td>
	</tr>

	<!-- ���� �޴� �ٷΰ��� ��� -->
	<tr>
		<td width="190" style="padding-top:5px;padding-bottom:5px">
			<%@ include file="/common/myFavorite.jsp" %>
		</td>
	</tr>

	<!-- �޽��� �ٿ�ε� ��ư -->
	<tr>
		<td width="" height=""><button style="height:30px;width:190px;">Messenger Download</button>
		</td>
	</tr>

	<!-- ���� ���� ����� ¥���� ������~~ -->
	<tr>
		<td height="40"></td>
	</tr>

</table>