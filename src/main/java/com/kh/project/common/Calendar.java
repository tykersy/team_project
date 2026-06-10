package com.kh.project.common;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.kh.project.dao.UserDAO;
import com.kh.project.vo.CalendarDayVO;
import com.kh.project.vo.TAVO;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class Calendar {

    private final UserDAO userDao;

    public List<CalendarDayVO> getCalendar(int sabun, int year, int month) {

    // 1. DB에서 해당 월 출근 데이터 조회
    Map<String, Object> map = new HashMap<>();
    map.put("sabun", sabun);
    map.put("year", year);
    map.put("month", month);
    List<TAVO> taList = userDao.getMonthlyTA(map);

    // 2. 날짜(String) → TAVO 맵으로 변환
    Map<String, TAVO> taMap = taList.stream()
            .collect(Collectors.toMap(TAVO::getDay, t -> t));

    // 3. 해당 월 전체 날짜 순회
    LocalDate today    = LocalDate.now();
    LocalDate firstDay = LocalDate.of(year, month, 1);
    int       lastDay  = firstDay.lengthOfMonth();

    List<CalendarDayVO> calendar = new ArrayList<>();

    for (int d = 1; d <= lastDay; d++) {
        LocalDate date    = LocalDate.of(year, month, d);
        DayOfWeek dow     = date.getDayOfWeek();

        // DB의 day 컬럼 형식에 맞게 (yyyy-MM-dd)
        String    dateKey = String.format("%d-%02d-%02d", year, month, d);
        TAVO      ta      = taMap.get(dateKey);

        String status;
        String checkin  = "-";
        String checkout = "-";

        if (dow == DayOfWeek.SATURDAY || dow == DayOfWeek.SUNDAY) {
            // 주말
            status = "off";

        } else if (date.isAfter(today)) {
            // 미래
            status = "future";

        } else if (ta == null) {
            // 평일 + 데이터 없음 → 결근
            status = "absent";

        } else {
            // DB status 사용 (normal / late)
            status  = ta.getStatus();
            checkin  = ta.getCheckin()  != null ? ta.getCheckin()  : "-";
            checkout = ta.getCheckout() != null ? ta.getCheckout() : "-";
        }

        calendar.add(new CalendarDayVO(d, status, checkin, checkout));
    }

    return calendar;
}
}
