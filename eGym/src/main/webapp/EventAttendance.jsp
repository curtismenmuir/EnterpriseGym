<%-- 
    Document   : EventAttendance
    Created on : Sep 21, 2015, 10:33:27 AM
    Author     : Yogi
--%>

<%@page import="Stores.LoggedIn"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Iterator"%>
<%@page import="Stores.BasicUser"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp"></jsp:include>
    <script>

        $(document).ready(function () {

            function exportTableToCSV($table, filename) {

                var $rows = $table.find('tr:has(td)'),
                        // Temporary delimiter characters unlikely to be typed by keyboard
                        // This is to avoid accidentally splitting the actual contents
                        tmpColDelim = String.fromCharCode(11), // vertical tab character
                        tmpRowDelim = String.fromCharCode(0), // null character

                        // actual delimiter characters for CSV format
                        colDelim = '","',
                        rowDelim = '"\r\n"',
                        // Grab text from table into CSV formatted string
                        csv = '"' + $rows.map(function (i, row) {
                            var $row = $(row),
                                    $cols = $row.find('td');

                            return $cols.map(function (j, col) {
                                var $col = $(col),
                                        text = $col.text();

                                return text.replace(/"/g, '""'); // escape double quotes

                            }).get().join(tmpColDelim);

                        }).get().join(tmpRowDelim)
                        .split(tmpRowDelim).join(rowDelim)
                        .split(tmpColDelim).join(colDelim) + '"',
                        // Data URI
                        csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csv);

                $(this)
                        .attr({
                            'download': filename,
                            'href': csvData,
                            'target': '_blank'
                        });
            }

            // This must be a hyperlink
            $(".export").on('click', function (event) {
                // CSV
                exportTableToCSV.apply(this, [$('#dvData>table'), 'export.csv']);

                // IF CSV, don't do event.preventDefault() or return false
                // We actually need this to be a typical hyperlink
            });
        });

    </script>

<%
    LinkedList<BasicUser> attendees = (LinkedList<BasicUser>) request.getAttribute("Users");
    Integer activityid = (Integer) request.getAttribute("ActivityID");
%>

<script>
    function myFunction(x) {
        $.get(x, function (data, status) {
            location.reload();
        });
    }
</script>
<div id="services" class="pad-section">
    <div class="container">
        <h1>Register Event Attendees</h1>



        <%
            LoggedIn lg = (LoggedIn) session.getAttribute("LoggedIn");
            if (lg != null && lg.isLoggedIn()) {
                String username = lg.getUsername();
                if (lg.getRole() == 2 || lg.getRole() == 3) {

                    for (BasicUser t : attendees) {
        %>
        <div class="panel panel-default">
            <div class="panel-heading">

                <h3 class="panel-title"><%=t.getUsername()%></h3>
            </div>
            <div class="panel-body">
                <%=t.getFirstName() + " " + t.getLastName() + " : " + t.getEmail()%><br>
                <button onclick="myFunction('<%="/eGym/RegisterAttendee/" + t.getUsername() + "/" + activityid%>')">Register Attendee</button>
            </div>
        </div>

        <div id="dvData" style="display: none;">
            <table>
                <tr>
                    <td><%=t.getUsername()%></td>
                    <td><%=t.getFirstName()%></td>
                    <td><%=t.getLastName()%></td>
                    <td><%=t.getEmail()%></td>
                </tr>
            </table>
        </div>

        <%}%>
        <a href="#" class="export">Export into CSV</a>
        <%} else {
        %>
        You do not have permissions to access this page
        <%
            }
        } else {
        %>
        Sign in to access this page
        <%}%>
    </div>
</div>
<jsp:include page="footer.jsp"></jsp:include>
