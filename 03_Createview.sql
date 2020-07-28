USE [TOE_DB];
GO
Create view dbo.Main_report
as
select 
		CONCAT(sort,'.',count(sort) over (PARTITION BY SORT order by sort asc, sort2 asc)) NN
		,ID_TAB
		,FIO
		,position_1
		,summary_of_dalary
	    ,StartDay
		,EndDay
		,worked_days
		,ROUND(salary_by_report,2) salary_by_report
from
	(select 
		result_2.ID_TAB
		,jobs.ID_DEPT sort
		,result_2.ID_TAB sort2
		,result_2.FIO
		,(select Position from positions where result_2.ID_TAB = positions.ID_TAB ) position_1
		,MAX(result_2.sumsalary) summary_of_dalary
	    ,(select MAX(Startdate) from reportdates) StartDay
		,(select MAX(EndDate) from reportdates) EndDay
		,Count(*) worked_days
		,Count(*)*SUM(CAST(sss.salary as real)/cast(calendarOf2020.workday as real)) salary_by_report
	from 
		(select
				result_1.ID_TAB
				,result_1.FIO
				,result_1.Position
				,summ_of_salarys_emp.sumsalary
		from 
			(select 
				emp.ID_TAB
				,emp.FIO
				,pos.Position
			from 
				employes emp, positions pos
			where pos.ID_TAB = emp.ID_TAB) result_1
		LEFT JOIN 
			(select 
				ID_TAB,
				Sum(salary) sumsalary
			from salarys
			group by ID_TAB
			) summ_of_salarys_emp
			on (summ_of_salarys_emp.ID_TAB = result_1.ID_TAB)
		) result_2, jobs
	left join calendarOf2020 on (jobs.ID_DAY = calendarOf2020.ID_DAY)
	left join salarys sss on (sss.ID_TAB = jobs.ID_TAB) and (sss.ID_DEPT = jobs.ID_DEPT)
	where (result_2.ID_TAB = jobs.ID_TAB)
		and
			calendarOf2020.daysofyear >= (select MAX(Startdate) from reportdates) 
		and 
			calendarOf2020.daysofyear <= (select MAX(Enddate) from reportdates) 
	Group by 	result_2.ID_TAB, jobs.ID_DEPT, result_2.FIO
	--order by jobs.ID_DEPT	
UNION ALL
	select 
		global_report.ID_DEPT
		,global_report.ID_DEPT sort
		,0 sort2
		,(select name_of_dept from departments where global_report.ID_DEPT = departments.ID_DEPT) FIO
		,CAST(SUM(global_report.Cnt) As nchar) position_1
		,SUM(global_report.summary_of_dalary) summary_of_dalary
		,(select MAX(Startdate) from reportdates) StartDay
		,(select MAX(EndDate) from reportdates) EndDay
		,SUM(global_report.worked_days) worked_days
		,SUM(global_report.salary_by_report) salary_by_report
	from
		(select 
			result_2.ID_TAB
			,jobs.ID_DEPT
			,1 Cnt
			,MAX(result_2.sumsalary) summary_of_dalary
			,Count(*) worked_days
			,Count(*)*SUM(CAST(sss.salary as real)/cast(calendarOf2020.workday as real)) salary_by_report
		from 
			(select
					result_1.ID_TAB
					,result_1.FIO
					,result_1.Position
					,summ_of_salarys_emp.sumsalary
			from 
				(select 
					emp.ID_TAB
					,emp.FIO
					,pos.Position
				from 
					employes emp, positions pos
				where pos.ID_TAB = emp.ID_TAB) result_1
			LEFT JOIN 
				(select 
					ID_TAB,
					Sum(salary) sumsalary
				from salarys
				group by ID_TAB
				) summ_of_salarys_emp
				on (summ_of_salarys_emp.ID_TAB = result_1.ID_TAB)
			) result_2, jobs
		left join calendarOf2020 on (jobs.ID_DAY = calendarOf2020.ID_DAY)
		left join salarys sss on (sss.ID_TAB = jobs.ID_TAB) and (sss.ID_DEPT = jobs.ID_DEPT)
		where (result_2.ID_TAB = jobs.ID_TAB)
			and
				calendarOf2020.daysofyear >= (select MAX(Startdate) from reportdates) 
			and 
				calendarOf2020.daysofyear <= (select MAX(Enddate) from reportdates) 
		Group by 	result_2.ID_TAB, jobs.ID_DEPT, result_2.FIO
		) global_report
	group by ID_DEPT) finaly_r	
GO
