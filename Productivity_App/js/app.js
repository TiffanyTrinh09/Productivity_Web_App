var _taskForm = null;
var _taskId = null;
var _taskName = null;
var _taskDescription = null;
var _taskCategory = null;
var _taskDate = null;
var _taskColor = null;
var _taskStatus = null;
var _taskList = null;

var _eventForm = null;
var _eventId = null;
var _eventDescription = null;
var _eventCategory = null;
var _eventStartDate = null;
var _eventEndDate = null;
var _eventList = null;

var _displayTypeId = 0;

function init() {
    _taskForm = document.getElementById("_task_form");
    _taskId = document.getElementById("_task_id");
    _taskName = document.getElementById("_task_name");
    _taskDescription = document.getElementById("_task_description");
    _taskCategory = document.getElementById("_task_category");
    _taskDate = document.getElementById("_task_date");
    _taskColor = document.getElementById("_task_color");
    _taskStatus = document.getElementById("_task_status");
    _taskList = document.getElementById("_task_list");

    _eventForm = document.getElementById("_event_form");
    _eventId = document.getElementById("_event_id");
    _eventDescription = document.getElementById("_event_description");
    _eventCategory = document.getElementById("_event_category");
    _eventStartDate = document.getElementById("_event_start_date");
    _eventEndDate = document.getElementById("_event_end_date");
    _eventList = document.getElementById("_event_list");

    get_task_list();
    get_event_list();
}

function get_task_list() {
    sendReq({
        type: "GET",
        url: "ProdSvc.ashx?Req_Cmd=GET_TASK_LIST&Display_Type_Id=" + _displayTypeId,
        onResponse: function (result) {
            var r = JSON.parse(result);
            if (r.error != "") {
                alert("Failed to get task list");
            }
            else {
                var htmlTxt = "<div>";
                var ds = r.data;
                var status = "";
                for (var i = 0; i < ds.length; i++) {
                    htmlTxt += "<div class='task_item' style='background-color:#" + ds[i].color + "'><span style='display:inline-block;vertical-align:top;width:600px'>";
                    htmlTxt += "<div><span>Name: </span><span>" + ds[i].name + "</span></div>";
                    htmlTxt += "<div><span>Description: </span><span>" + ds[i].description + "</span></div>";
                    htmlTxt += "<div><span>Date: </span><span>" + ds[i].date + "</span></div>";
                    htmlTxt += "<div><span>Category: </span><span>" + ds[i].category + "</span></div>";
                    htmlTxt += "<div><span>Completed: </span><span>" + (ds[i].isCompleted == "1" ? "Yes" : "No") + "</span></div>";
                    htmlTxt += "</span><span class='task_menu'><span onclick='show_task_form(" + ds[i].id + ")'>Edit</span><span onclick='delete_task_info(" + ds[i].id + ")'>Delete</span></span></div>";
                }
                htmlTxt += "</div>";
                _taskList.innerHTML = htmlTxt;
            }
        }
    })
}
function get_task_info(taskId) {
    sendReq({
        type: "GET",
        url: "ProdSvc.ashx?Req_Cmd=GET_TASK_INFO&Task_Id=" + taskId,
        onResponse: function (result) {
            var r = JSON.parse(result);
            if (r.error != "") {
                alert("Failed to get task info");
            }
            else {
                _taskId.value = r.data.id;
                _taskName.value = r.data.name;
                _taskDescription.value = r.data.description;
                _taskCategory.value = r.data.category;
                _taskDate.value = r.data.date;
                _taskColor.value = r.data.color;
                _taskStatus.checked = r.data.isCompleted == "1" ? true : false;
            }
        }
    })
}
function clear_task_form() {
    _taskId.value = "";
    _taskName.value = "";
    _taskDescription.value = "";
    _taskCategory.value = "";
    _taskDate.value = "";
    _taskColor.value = "";
    _taskStatus.checked = false;
}
function close_task_form() {
    _taskForm.style.display = "none";
}
function delete_task_info(taskId) {
    sendReq({
        type: "GET",
        url: "ProdSvc.ashx?Req_Cmd=DELETE_TASK_INFO&Task_Id=" + taskId,
        onResponse: function (result) {
            var r = JSON.parse(result);
            if (r.error != "") {
                alert("Failed to delete task info");
            }
            else {
                get_task_list();
            }
        }
    })
}
function show_task_form(taskId) {
    if (taskId != 0)
        get_task_info(taskId);
    else
        clear_task_form();
    _taskForm.style.display = "inline-block";
}
function submit_task() {
    var taskInfo =
    {
        id: _taskId.value,
        name: _taskName.value,
        description: _taskDescription.value,
        category: _taskCategory.value,
        date: _taskDate.value,
        isCompleted: _taskStatus.checked == true ? 1 : 0,
        color: _taskColor.value
    };

    sendReq({
        type: "GET",
        async: true,
        url: "ProdSvc.ashx?Req_Cmd=SAVE_TASK_INFO"
            + "&Task_Id=" + taskInfo.id
            + "&Task_Name=" + encodeURIComponent(taskInfo.name)
            + "&Task_Description=" + encodeURIComponent(taskInfo.description)
            + "&Task_Category=" + encodeURIComponent(taskInfo.category)
            + "&Task_Date=" + taskInfo.date
            + "&Completion_Status=" + taskInfo.isCompleted
            + "&Color=" + encodeURIComponent(taskInfo.color)
        ,
        contentType: "application/text",
        data: null,
        onResponse: function () {
            close_task_form();
            get_task_list();
        },
        timeout: 0,
    })
}




function get_event_list() {
    sendReq({
        type: "GET",
        url: "ProdSvc.ashx?Req_Cmd=GET_EVENT_LIST&Display_Type_Id=" + _displayTypeId,
        onResponse: function (result) {
            var r = JSON.parse(result);
            if (r.error != "") {
                alert("Failed to get event list");
            }
            else {
                var htmlTxt = "<div>";
                var ds = r.data;
                for (var i = 0; i < ds.length; i++) {
                    htmlTxt += "<div class='event_item'><span style='display:inline-block;vertical-align:top;width:600px'>";
                    htmlTxt += "<div><span>Description: </span><span>" + ds[i].description + "</span></div>";
                    htmlTxt += "<div><span>Category: </span><span>" + ds[i].category + "</span></div>";
                    htmlTxt += "<div><span>Start Date: </span><span>" + ds[i].startDate + "</span></div>";
                    htmlTxt += "<div><span>End Date: </span><span>" + ds[i].endDate + "</span></div>";
                    htmlTxt += "</span><span class='event_menu'><span onclick='show_event_form(" + ds[i].id + ")'>Edit</span><span onclick='delete_event_info(" + ds[i].id + ")'>Delete</span></span></div>";
                }
                htmlTxt += "</div";
                _eventList.innerHTML = htmlTxt;
            }
        }
    })
}
function get_event_info(eventId) {
    sendReq({
        type: "GET",
        url: "ProdSvc.ashx?Req_Cmd=GET_EVENT_INFO&Event_Id=" + eventId,
        onResponse: function (result) {
            var r = JSON.parse(result);
            if (r.error != "") {
                alert("Failed to get event info");
            }
            else {
                _eventId.value = r.data.id;
                _eventDescription.value = r.data.description;
                _eventCategory.value = r.data.category;
                _eventStartDate.value = r.data.startDate;
                _eventEndDate.value = r.data.endDate;
            }
        }
    })
}
function clear_event_form() {
    _eventId.value = "";
    _eventDescription.value = "";
    _eventCategory.value = "";
    _eventStartDate.value = "";
    _eventEndDate.value = "";
}
function close_event_form() {
    _eventForm.style.display = "none";
}
function delete_event_info(eventId) {
    sendReq({
        type: "GET",
        url: "ProdSvc.ashx?Req_Cmd=DELETE_EVENT_INFO&Event_Id=" + eventId,
        onResponse: function (result) {
            var r = JSON.parse(result);
            if (r.error != "") {
                alert("Failed to delete event info");
            }
            else {
                get_event_list();
            }
        }
    })
}
function show_event_form(eventId) {
    if (eventId != 0)
        get_event_info(eventId);
    else
        clear_event_form();
    _eventForm.style.display = "inline-block";
}
function submit_event() {
    var eventInfo =
    {
        id: _eventId.value,
        description: _eventDescription.value,
        category: _eventCategory.value,
        startDate: _eventStartDate.value,
        endDate: _eventEndDate.value
    };

    sendReq({
        type: "GET",
        async: true,
        url: "ProdSvc.ashx?Req_Cmd=SAVE_EVENT_INFO"
            + "&Event_Id=" + eventInfo.id
            + "&Event_Description=" + encodeURIComponent(eventInfo.description)
            + "&Event_Category=" + encodeURIComponent(eventInfo.category)
            + "&Start_Date=" + eventInfo.startDate
            + "&End_Date=" + eventInfo.endDate
        ,
        contentType: "application/text",
        data: null,
        onResponse: function () {
            close_event_form();
            get_event_list();
        },
        timeout: 0,
    })
}



function toggle_view(displayTypeId) {
    _displayTypeId = displayTypeId;
    get_task_list();
    get_event_list();
}