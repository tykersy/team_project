            console.log("loaded");
            
            function openDateBox(){
                document.getElementById("dateModal")
                        .style.display = "flex";
            }

            function closeDateModal(){
                document.getElementById("dateModal")
                        .style.display = "none";
            }

            function moveDate(){

                let year =
                document.getElementById("year").value;

                let month =
                document.getElementById("month").value;

                location.href =
                "calendar_calendarmain?year="+year+
                "&month="+month;
            }
            function insertSchedule(){
                const menu = document.getElementById("bottomMenu");
                const btn = document.getElementById("bottomBtn");

                menu.classList.toggle("active");
                btn.classList.toggle("open");

                if(menu.classList.contains("active")){
                    btn.innerText = "☰";
                }else{
                    btn.innerText = "☰";
                }
            }

            function openDcalDetail(idx,title,start,end,content,writerSabun){

                document.getElementById("scheduleIdx").value = idx;
                document.getElementById("scheduleType").value = "dcal";

                document.getElementById("detailTitle").innerText = title;
                document.getElementById("detailStart").innerText = start.substring(0, 10);
                document.getElementById("detailEnd").innerText = end.substring(0, 10);
                document.getElementById("detailContent").innerText = content;

                setOwnerButtons(writerSabun);

                document.getElementById("detailModal")
                        .style.display = "flex";
            }

            function openScalDetail(idx,title,start,end,content,writerSabun){

                document.getElementById("scheduleIdx").value = idx;
                document.getElementById("scheduleType").value = "scal";

                document.getElementById("detailTitle").innerText = title;
                document.getElementById("detailStart").innerText = start.substring(0, 10);
                document.getElementById("detailEnd").innerText = end.substring(0, 10);
                document.getElementById("detailContent").innerText = content;

                setOwnerButtons(writerSabun);

                document.getElementById("detailModal")
                        .style.display = "flex";
            }

            function closeDetailModal(){

                document.getElementById("detailModal")
                        .style.display = "none";
            }
            function setOwnerButtons(writerSabun){

                const isWriter = Number(writerSabun) === Number(loginSabun);

                document.getElementById("modifyBtn").style.display =
                    isWriter ? "inline-block" : "none";

                document.getElementById("deleteBtn").style.display =
                    isWriter ? "inline-block" : "none";
            }
            function modifySchedule(){

                const idx = document.getElementById("scheduleIdx").value;
                const type = document.getElementById("scheduleType").value;

                location.href = "schedule_modify.do?idx=" + idx + "&type=" + type;
            }

            function deleteSchedule(){

                const idx = document.getElementById("scheduleIdx").value;
                const type = document.getElementById("scheduleType").value;

                if(!confirm("삭제하시겠습니까?")){
                    return;
                }

                fetch("delete_schedule.do", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "idx=" + idx + "&type=" + type
                })
                .then(res => res.json())
                .then(data => {
                    if(data.status === "success"){
                        alert("삭제되었습니다.");
                        location.reload();
                    }else{
                        alert("삭제 실패");
                    }
                });
            }