<%@LANGUAGE="VBSCRIPT" CODEPAGE="950"%> 
<!--#include file="Connections/DB.asp" -->
<%
Dim rsBulletin__mMSG
rsBulletin__mMSG = "%"
If (Request.QueryString("Message") <> "") Then 
  rsBulletin__mMSG = Request.QueryString("Message")
End If
%>
<%
Dim rsBulletin__mOL
rsBulletin__mOL = "%"
If (Request.QueryString("OnLine") <> "") Then 
  rsBulletin__mOL = Request.QueryString("OnLine")
End If
%>
<%
Dim rsBulletin
Dim rsBulletin_numRows

Set rsBulletin = Server.CreateObject("ADODB.Recordset")
rsBulletin.ActiveConnection = MM_DB_STRING
rsBulletin.Source = "SELECT *  FROM Bulletin  WHERE Label LIKE '%" + Replace(rsBulletin__mMSG, "'", "''") + "%' AND OnLine LIKE '" + Replace(rsBulletin__mOL, "'", "''") + "%'  ORDER BY SID"
rsBulletin.CursorType = 0
rsBulletin.CursorLocation = 2
rsBulletin.LockType = 1
rsBulletin.Open()

rsBulletin_numRows = 0
%>
<%
Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = 20
Repeat1__index = 0
rsBulletin_numRows = rsBulletin_numRows + Repeat1__numRows
%>
<%
'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

Dim rsBulletin_total
Dim rsBulletin_first
Dim rsBulletin_last

' set the record count
rsBulletin_total = rsBulletin.RecordCount

' set the number of rows displayed on this page
If (rsBulletin_numRows < 0) Then
  rsBulletin_numRows = rsBulletin_total
Elseif (rsBulletin_numRows = 0) Then
  rsBulletin_numRows = 1
End If

' set the first and last displayed record
rsBulletin_first = 1
rsBulletin_last  = rsBulletin_first + rsBulletin_numRows - 1

' if we have the correct record count, check the other stats
If (rsBulletin_total <> -1) Then
  If (rsBulletin_first > rsBulletin_total) Then
    rsBulletin_first = rsBulletin_total
  End If
  If (rsBulletin_last > rsBulletin_total) Then
    rsBulletin_last = rsBulletin_total
  End If
  If (rsBulletin_numRows > rsBulletin_total) Then
    rsBulletin_numRows = rsBulletin_total
  End If
End If
%>
<%
' *** Recordset Stats: if we don't know the record count, manually count them

If (rsBulletin_total = -1) Then

  ' count the total records by iterating through the recordset
  rsBulletin_total=0
  While (Not rsBulletin.EOF)
    rsBulletin_total = rsBulletin_total + 1
    rsBulletin.MoveNext
  Wend

  ' reset the cursor to the beginning
  If (rsBulletin.CursorType > 0) Then
    rsBulletin.MoveFirst
  Else
    rsBulletin.Requery
  End If

  ' set the number of rows displayed on this page
  If (rsBulletin_numRows < 0 Or rsBulletin_numRows > rsBulletin_total) Then
    rsBulletin_numRows = rsBulletin_total
  End If

  ' set the first and last displayed record
  rsBulletin_first = 1
  rsBulletin_last = rsBulletin_first + rsBulletin_numRows - 1
  
  If (rsBulletin_first > rsBulletin_total) Then
    rsBulletin_first = rsBulletin_total
  End If
  If (rsBulletin_last > rsBulletin_total) Then
    rsBulletin_last = rsBulletin_total
  End If

End If
%>
<%
Dim MM_paramName 
%>
<%
' *** Move To Record and Go To Record: declare variables

Dim MM_rs
Dim MM_rsCount
Dim MM_size
Dim MM_uniqueCol
Dim MM_offset
Dim MM_atTotal
Dim MM_paramIsDefined

Dim MM_param
Dim MM_index

Set MM_rs    = rsBulletin
MM_rsCount   = rsBulletin_total
MM_size      = rsBulletin_numRows
MM_uniqueCol = ""
MM_paramName = ""
MM_offset = 0
MM_atTotal = false
MM_paramIsDefined = false
If (MM_paramName <> "") Then
  MM_paramIsDefined = (Request.QueryString(MM_paramName) <> "")
End If
%>
<%
' *** Move To Record: handle 'index' or 'offset' parameter

if (Not MM_paramIsDefined And MM_rsCount <> 0) then

  ' use index parameter if defined, otherwise use offset parameter
  MM_param = Request.QueryString("index")
  If (MM_param = "") Then
    MM_param = Request.QueryString("offset")
  End If
  If (MM_param <> "") Then
    MM_offset = Int(MM_param)
  End If

  ' if we have a record count, check if we are past the end of the recordset
  If (MM_rsCount <> -1) Then
    If (MM_offset >= MM_rsCount Or MM_offset = -1) Then  ' past end or move last
      If ((MM_rsCount Mod MM_size) > 0) Then         ' last page not a full repeat region
        MM_offset = MM_rsCount - (MM_rsCount Mod MM_size)
      Else
        MM_offset = MM_rsCount - MM_size
      End If
    End If
  End If

  ' move the cursor to the selected record
  MM_index = 0
  While ((Not MM_rs.EOF) And (MM_index < MM_offset Or MM_offset = -1))
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend
  If (MM_rs.EOF) Then 
    MM_offset = MM_index  ' set MM_offset to the last possible record
  End If

End If
%>
<%
' *** Move To Record: if we dont know the record count, check the display range

If (MM_rsCount = -1) Then

  ' walk to the end of the display range for this page
  MM_index = MM_offset
  While (Not MM_rs.EOF And (MM_size < 0 Or MM_index < MM_offset + MM_size))
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend

  ' if we walked off the end of the recordset, set MM_rsCount and MM_size
  If (MM_rs.EOF) Then
    MM_rsCount = MM_index
    If (MM_size < 0 Or MM_size > MM_rsCount) Then
      MM_size = MM_rsCount
    End If
  End If

  ' if we walked off the end, set the offset based on page size
  If (MM_rs.EOF And Not MM_paramIsDefined) Then
    If (MM_offset > MM_rsCount - MM_size Or MM_offset = -1) Then
      If ((MM_rsCount Mod MM_size) > 0) Then
        MM_offset = MM_rsCount - (MM_rsCount Mod MM_size)
      Else
        MM_offset = MM_rsCount - MM_size
      End If
    End If
  End If

  ' reset the cursor to the beginning
  If (MM_rs.CursorType > 0) Then
    MM_rs.MoveFirst
  Else
    MM_rs.Requery
  End If

  ' move the cursor to the selected record
  MM_index = 0
  While (Not MM_rs.EOF And MM_index < MM_offset)
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend
End If
%>
<%
' *** Move To Record: update recordset stats

' set the first and last displayed record
rsBulletin_first = MM_offset + 1
rsBulletin_last  = MM_offset + MM_size

If (MM_rsCount <> -1) Then
  If (rsBulletin_first > MM_rsCount) Then
    rsBulletin_first = MM_rsCount
  End If
  If (rsBulletin_last > MM_rsCount) Then
    rsBulletin_last = MM_rsCount
  End If
End If

' set the boolean used by hide region to check if we are on the last record
MM_atTotal = (MM_rsCount <> -1 And MM_offset + MM_size >= MM_rsCount)
%>
<%
' *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

Dim MM_keepNone
Dim MM_keepURL
Dim MM_keepForm
Dim MM_keepBoth

Dim MM_removeList
Dim MM_item
Dim MM_nextItem

' create the list of parameters which should not be maintained
MM_removeList = "&index="
If (MM_paramName <> "") Then
  MM_removeList = MM_removeList & "&" & MM_paramName & "="
End If

MM_keepURL=""
MM_keepForm=""
MM_keepBoth=""
MM_keepNone=""

' add the URL parameters to the MM_keepURL string
For Each MM_item In Request.QueryString
  MM_nextItem = "&" & MM_item & "="
  If (InStr(1,MM_removeList,MM_nextItem,1) = 0) Then
    MM_keepURL = MM_keepURL & MM_nextItem & Server.URLencode(Request.QueryString(MM_item))
  End If
Next

' add the Form variables to the MM_keepForm string
For Each MM_item In Request.Form
  MM_nextItem = "&" & MM_item & "="
  If (InStr(1,MM_removeList,MM_nextItem,1) = 0) Then
    MM_keepForm = MM_keepForm & MM_nextItem & Server.URLencode(Request.Form(MM_item))
  End If
Next

' create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL & MM_keepForm
If (MM_keepBoth <> "") Then 
  MM_keepBoth = Right(MM_keepBoth, Len(MM_keepBoth) - 1)
End If
If (MM_keepURL <> "")  Then
  MM_keepURL  = Right(MM_keepURL, Len(MM_keepURL) - 1)
End If
If (MM_keepForm <> "") Then
  MM_keepForm = Right(MM_keepForm, Len(MM_keepForm) - 1)
End If

' a utility function used for adding additional parameters to these strings
Function MM_joinChar(firstItem)
  If (firstItem <> "") Then
    MM_joinChar = "&"
  Else
    MM_joinChar = ""
  End If
End Function
%>
<%
' *** Move To Record: set the strings for the first, last, next, and previous links

Dim MM_keepMove
Dim MM_moveParam
Dim MM_moveFirst
Dim MM_moveLast
Dim MM_moveNext
Dim MM_movePrev

Dim MM_urlStr
Dim MM_paramList
Dim MM_paramIndex
Dim MM_nextParam

MM_keepMove = MM_keepBoth
MM_moveParam = "index"

' if the page has a repeated region, remove 'offset' from the maintained parameters
If (MM_size > 1) Then
  MM_moveParam = "offset"
  If (MM_keepMove <> "") Then
    MM_paramList = Split(MM_keepMove, "&")
    MM_keepMove = ""
    For MM_paramIndex = 0 To UBound(MM_paramList)
      MM_nextParam = Left(MM_paramList(MM_paramIndex), InStr(MM_paramList(MM_paramIndex),"=") - 1)
      If (StrComp(MM_nextParam,MM_moveParam,1) <> 0) Then
        MM_keepMove = MM_keepMove & "&" & MM_paramList(MM_paramIndex)
      End If
    Next
    If (MM_keepMove <> "") Then
      MM_keepMove = Right(MM_keepMove, Len(MM_keepMove) - 1)
    End If
  End If
End If

' set the strings for the move to links
If (MM_keepMove <> "") Then 
  MM_keepMove = MM_keepMove & "&"
End If

MM_urlStr = Request.ServerVariables("URL") & "?" & MM_keepMove & MM_moveParam & "="

MM_moveFirst = MM_urlStr & "0"
MM_moveLast  = MM_urlStr & "-1"
MM_moveNext  = MM_urlStr & CStr(MM_offset + MM_size)
If (MM_offset - MM_size < 0) Then
  MM_movePrev = MM_urlStr & "0"
Else
  MM_movePrev = MM_urlStr & CStr(MM_offset - MM_size)
End If
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>首頁連結維護</title>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_goToURL() { //v3.0
  var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
  for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
}
//-->
</script>
</head>

<body background="images/tail-top.gif">
<table width="100%" border="0">
  <tr> 
    <td width="69%"><font color="#990000">首頁連結維護</font></td>
    <td width="31%"> <div align="right"><a href="javascript:window.top.close()">關閉視窗</a> 
      </div></td>
  </tr>
  <tr> 
    <td><form name="form1" method="get" action="BulletinList.asp">
        <div align="left"><font size="2">標簽： 
          <input name="Message" type="text" id="Message" value="<%=Request.QueryString("Message")%>" size="30">
          上架： 
          <select name="OnLine" id="OnLine">
            <option value="%" <%If (Not isNull(Request.QueryString("OnLine"))) Then If ("%" = CStr(Request.QueryString("OnLine"))) Then Response.Write("SELECTED") : Response.Write("")%>>全部</option>
            <option value="Yes" <%If (Not isNull(Request.QueryString("OnLine"))) Then If ("Yes" = CStr(Request.QueryString("OnLine"))) Then Response.Write("SELECTED") : Response.Write("")%>>Yes</option>
            <option value="No" <%If (Not isNull(Request.QueryString("OnLine"))) Then If ("No" = CStr(Request.QueryString("OnLine"))) Then Response.Write("SELECTED") : Response.Write("")%>>No</option>
          </select>
          <input name="Submit" type="submit" class="btn01" value="搜尋">
          </font></div>
      </form></td>
    <td>&nbsp;</td>
  </tr>
</table>
<table width="100%" height="10" border="1" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="5%" bgcolor="#CCFFFF"> <div align="center"><font size="2">序號</font></div></td>
    <td width="15%" bgcolor="#CCFFFF"> <div align="center"><font size="2">標簽</font></div></td>
    <td width="25%" bgcolor="#CCFFFF"> <div align="center"><font size="2">超連結</font></div></td>
    <td width="10%" bgcolor="#CCFFFF"> <div align="center"><font size="2">圖示</font></div></td>
    <td width="5%" bgcolor="#CCFFFF"><div align="center"><font size="2">新視窗</font></div></td>
    <td width="5%" bgcolor="#CCFFFF"><div align="center"><font size="2">等級</font></div></td>
    <td width="5%" bgcolor="#CCFFFF"> <div align="center"><font size="2">上架</font></div></td>
    <td width="8%"> <div align="center"><font size="2"><a href="BulletinListA.asp">新增</a></font></div></td>
  </tr>
  <% 
While ((Repeat1__numRows <> 0) AND (NOT rsBulletin.EOF)) 
%>
  <tr> 
    <td> 
      <div align="center"><font size="2" face="Arial, Helvetica, sans-serif"><%=(rsBulletin.Fields.Item("SID").Value)%></font></div></td>
    <td> 
      <div align="center"><font size="2" face="Arial, Helvetica, sans-serif"><%=(rsBulletin.Fields.Item("Label").Value)%></font><font size="2">&nbsp;</font></div></td>
    <td> 
      <div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><a href="<%=(rsBulletin.Fields.Item("URL").Value)%>" target="_blank"><%=(rsBulletin.Fields.Item("URL").Value)%></a></font></div></td>
    <td align="center" valign="middle"><font size="2"> 
      <% If Len(rsBulletin.Fields.Item("IMG").Value)>0 Then %>
      <a href="<%="images/" & linkFile(rsBulletin.Fields.Item("IMG").Value)%>" target="_blank"><img src="images/<%=(rsBulletin.Fields.Item("IMG").Value)%>" border="0"></a> 
      <% End If %>
      <% If 1=1 OR UCase(Session("MM_username"))=UCase(rsBulletin.Fields.Item("Poster").Value) Then %>
      <a href="BulletinDoc.asp?ID=<%=(rsBulletin.Fields.Item("ID").Value)%>" class="btn01"><br>
      上傳圖示</a> 
      <% End If %>
      </font></td>
    <td align="center" valign="middle"><font size="2" face="Arial, Helvetica, sans-serif"><%=(rsBulletin.Fields.Item("TBlank").Value)%><br>
      <%=(rsBulletin.Fields.Item("IMG").Value)%></font></td>
    <td align="center" valign="middle"><font size="2" face="Arial, Helvetica, sans-serif"><%=(rsBulletin.Fields.Item("mLevel").Value)%></font></td>
    <td align="center" valign="middle"><font size="2" face="Arial, Helvetica, sans-serif"><%=(rsBulletin.Fields.Item("OnLine").Value)%></font></td>
    <td align="center" valign="middle"><font size="2"> 
      <% If 1=1 or UCase(Session("MM_username"))=UCase(rsBulletin.Fields.Item("Poster").Value) Then %>
      <a href="BulletinListM.asp?ID=<%=(rsBulletin.Fields.Item("ID").Value)%>&offset=<%=Request.QueryString("offset")%>">修改</a>&nbsp;<a href="BulletinListD.asp?ID=<%=(rsBulletin.Fields.Item("ID").Value)%>&offset=<%=Request.QueryString("offset")%>">刪除</a> 
      <% Else %>
      &nbsp; 
      <% End If %>
      </font></td>
  </tr>
  <% 
  Repeat1__index=Repeat1__index+1
  Repeat1__numRows=Repeat1__numRows-1
  rsBulletin.MoveNext()
Wend
%>
</table>
<font size="2">記錄 <%=(rsBulletin_first)%> 到 <%=(rsBulletin_last)%> 共 <%=(rsBulletin_total)%>筆</font> 
<table border="0" width="50%" align="center">
  <tr> 
    <td width="23%" align="center"> <% If MM_offset <> 0 Then %>
      <a href="<%=MM_moveFirst%>">第一頁</a> 
      <% End If ' end MM_offset <> 0 %> </td>
    <td width="31%" align="center"> <% If MM_offset <> 0 Then %>
      <a href="<%=MM_movePrev%>">上一頁</a> 
      <% End If ' end MM_offset <> 0 %> </td>
    <td width="23%" align="center"> <% If Not MM_atTotal Then %>
      <a href="<%=MM_moveNext%>">下一頁</a> 
      <% End If ' end Not MM_atTotal %> </td>
    <td width="23%" align="center"> <% If Not MM_atTotal Then %>
      <a href="<%=MM_moveLast%>">最後一頁</a> 
      <% End If ' end Not MM_atTotal %> </td>
  </tr>
</table>

</body>
</html>
<%
rsBulletin.Close()
Set rsBulletin = Nothing
%>
