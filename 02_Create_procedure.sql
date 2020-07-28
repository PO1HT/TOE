USE [TOE_DB];
GO
-- N'Создаем хранимую процедуру [Update_ReportMonth] для взаимодействия с Access'
CREATE PROCEDURE [Update_ReportMonth]
	-- Add the parameters for the stored procedure here
	@StartMonth int,
	@EndMonth int
AS
	UPDATE ReportDates 
	SET StartDate = DATEFROMPARTS(2020,@StartMonth,1), 
	EndDate = case @EndMonth
				when 12 then DATEADD(day,-1,DATEFROMPARTS(2020+1,1,1))
				else	
					DATEADD(day,-1,DATEFROMPARTS(2020,@EndMonth+1,1))
				end

GO
