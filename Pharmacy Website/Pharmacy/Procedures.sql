 use pPharmacy
    -----Procedures----------------------------------------------

  create procedure Find_Dealer @id varchar(20)
    as begin
        select *
        from Dealer E
        where E.DealerID = @id;
    end
    exec Find_Dealer 1
---------------------------------------------------
    create procedure Find_Employ @id varchar(20)
    as begin
        select *
        from Employ E
        where E.EmpID = @id;
    end
    exec Find_Employ 2
	-----------------------------------------------
	   create procedure Find_Employ_Name @name varchar(40)
    as begin
        select *
        from Employ E
        where E.EmpName = @name;
    end
    exec Find_Employ_Name umair
	---------------------------------------------------
    create procedure Find_Price @id varchar(20)
    as begin
        select M.MedicineName, M.Price
        from Medicine M
        where M.MedicineID = @id;
    end

   exec Find_Price '11M'
    -------------------------------------------

    create procedure Find_Expiry @id varchar(20)
    as begin
        select M.MedicineName, M.Expiry
        from Medicine M
        where M.MedicineID = @id;
    end
exec Find_Expiry '11M'
    -------------------------------------------

    create procedure Who_took_these @id varchar(20)
    as begin
        select Productid,CustomerName
        from Customers
        where Productid = @id
    end
exec Who_took_these '11M'
    -------------------------------------------

    create procedure Find_All_Info @id varchar(20)
    as begin
        select M.MedicineName, C.CompanyName, C.ContactNumber, M.Price, M.Manufacturing, M.Expiry
        from Medicine M join Company C on M.CompanyID = C.CompanyID
        where M.MedicineID = @id
    end
    exec Find_All_Info '11M'

    -------------------------------------------
    create procedure Quantityleft @id varchar(20)
    as begin
        select M.MedicineName,Q.Quantityleft
        from Medicine M, Stock Q
        where Q.Productid=@id
    end
    exec Quantityleft '12M'
    -------------------------------------------
    create procedure PurchaseDates @id varchar(20)
    as begin
        select Medicineid,PurchaseDate
        from Purchase
        where Medicineid=@id
    end
    exec PurchaseDates '12M'
    
    -------------------------------------------
    create procedure CompanyName @id varchar(20)
    as begin
        select  CompanyID,CompanyName
        from  Company 
        where CompanyID= @id
    end
    exec CompanyName '10C'
    -------------------------------------------
    create procedure DealernamefromCompID @id varchar(20)
    as begin
        select  DealerID,Name
        from  Dealer
        where CompanyID= @id
    end
    
exec DealernamefromCompID '10C'
    ---------------------------------------

    create procedure Update_Expiry @d date, @id varchar(20)
    as begin
        declare @mag date
        select @mag = Manufacturing from Medicine
        IF (DATEDIFF(day, @mag, @d) < 0)
            BEGIN
            Print 'Invalid Expiry as it is less than manufacturing date of medicine (procedure Name "Update_Expiry")';
            END
        else
            begin
            update Medicine
            set Expiry = @d
            where MedicineID = @id
			  select M.MedicineName, M.Expiry
              from Medicine M
               where M.MedicineID = @id;
            end
    end
    exec Update_Expiry '2018-05-18' , '10C'   
    ------------------------------------------------
    create procedure Update_Manf @d date, @id varchar(20)
    as begin
        declare @exp date
        select @exp = Expiry from Medicine
        IF (DATEDIFF(day, @d, @exp) < 0)
            BEGIN
            Print 'Invalid Manufacturing as it is greater than expiry date of medicine (Procedure Name "Update_Manf")';
            END
        else
            begin
            update Medicine
            set Manufacturing = @d
            where MedicineID = @id
			  select M.MedicineName, M.Manufacturing
              from Medicine M
               where M.MedicineID = @id;
            end
        end

exec Update_Manf '2017-01-10'  , '12M'  
        --------------------------------------------
		create procedure InsertCustomer @id varchar(20), @name varchar(20),@Productid varchar(20),@Quantity float,@price float
		as begin
		insert into [Customers]
		values (@id,@name,@Productid,@Quantity,@price)
		end

exec InsertCustomer '12C', 'obaid' , '12M' , 2 ,2000

		 --------------------------------------------
    
	create procedure SignupDatabase @id varchar(20), @name varchar(40), @contact varchar(11), @adrs varchar(40), @desig varchar(20), @sal int, @Email varchar(25), @usrn varchar(20), @pass varchar(20), @output int output
        as begin
            if(@usrn = (select UserName from LoginTable where UserName = @usrn))
                begin
                select @output = '0'
                end
            else
                begin
                insert into [Employ]
                values (@id, @name, @contact, @adrs, @desig, @sal, @Email)
                insert into [LoginTable]
                values (@usrn, @pass, @id)
                select @output = '1'
                end
        end
        exec SignupDatabase 1 , 'obaid' , 12345, 'rawalpindi' ,'Admin' ,100000, 'obaid@gmail.com' , 'obaid' , 'obaid' , 11
		
            --------------------------------------------
    create procedure LoginDatabase @usr varchar(20), @pas varchar(20), @ans int output
        as begin
            if(@pas = (select Pass from LoginTable where UserName = @usr))
                begin
                select @ans = 1;
                end
            else
                begin
                select @ans = 0;
                end
        end
        
exec LoginDatabase 'obaid1' , 123 ,12
            ---------------------------------------
     create procedure Show_All_Expired
        as begin
            select M.MedicineID, M.MedicineName, M.Expiry as 'Expired on'
            from Medicine M
            where DATEDIFF(day, M.Expiry, GETDATE()) > 0
        end
        
        exec Show_All_Expired
            ----------------------------------------
    create procedure Show_If_Expired @id varchar(20)
        as begin
            declare @dateofmed date
            select @dateofmed = M.Expiry from Medicine M where M.MedicineID = @id
            if(DATEDIFF(day, @dateofmed, GETDATE()) > 0)
                begin
                print 'This Medicine is expired'
                end
            else
                begin
                print 'This Medicine is not expired'
                end
        end
         exec Show_If_Expired '11M'
            --------------------------------------------
    create procedure Show_outofstock
        as begin
            select M.MedicineID, M.MedicineName
            from Medicine M join Stock S on M.MedicineID = S.Productid
            where S.Quantityleft = 0
        end
         exec Show_outofstock

            --------------------------------------------
                create procedure Show_All_Medicine
        as begin
            select *
            from Medicine
        end
        
        exec Show_All_Medicine
        -----------------

    create procedure noOfSale @id varchar(20)
        as begin 
            select MedicineID, Quantity, price, Totalprice
            from Sales
            where MedicineID = @id
        end
        exec noOfSale '11M'
-------------------------
    create procedure customer_database @id varchar(20), @name varchar(20),@mid varchar(20), @quantity float , @amount float
        as begin 
        insert into [Customers]
        values( @id,@name ,@mid, @quantity, @amount )

        end

exec customer_database '13C' , 'usman' , '11M' , 2 , 2000
		
		

--------------------
	  create procedure Purchaseoutput @PurchaseID varchar(20),@DealerID varchar (20),@Medicineid varchar(20),@PurchaseDate date,@Quantity float,@price float,@Totalprice float
	  as begin
	  insert into [Purchase]
	  values(@PurchaseID,@DealerID,@Medicineid,@PurchaseDate,@Quantity,@price,@Totalprice)
	  end

exec Purchaseoutput '9P', '11D' , '11M' , '2018-02-07' , 5 , 10 , 50






















-----------------------------
		create procedure CustomerBill @id varchar(20)
	  as begin
	  declare @cus varchar (20)
	  declare @sum float=0;
	   declare @sum2 float=0;  
	   declare @name varchar(20);
	   declare @med varchar(20)
	    declare @qu float;
		declare @pr float;
	   select @name=CustomerName,@med=Productid,@qu=Quantity,@pr=price from Customers
	   where CustomerID=@id
	  select @sum= sum(C.Quantity*M.Price)
	  from Customers C, Medicine M
	  where C.CustomerID=@id AND M.MedicineID=C.Productid
	 select @cus=CustomerID from repeatedCustomers
	 where @id=CustomerID
	 if (@cus is not NULL)
	 begin 
	  select @sum2= sum(C.Quantity*M.Price)
	  from repeatedCustomers C, Medicine M
	  where C.CustomerID=@cus AND M.MedicineID=C.Productid
	  select @sum2
	 end
	 declare @finalsum float= 0;
	 set @finalsum=@sum + @sum2
	 declare @pric float;
	 select @pric=price
	 from Customers
	 where CustomerID=@id
	 declare @remain float =0;
	 set @remain=@pric-@finalsum
	 select @remain
	 if (@remain>=0)
	 begin
	 declare @quan float;
	 declare @mi varchar(20);
	 insert into [Bill]
	 values (@id,@pric,@remain)
	 declare @stockquantity float;
	 select @quan=Quantityleft,@mi=Productid
	 from virtualStock
	 delete from virtualStock
	 update Stock set Quantityleft =@quan where Productid=@mi
	 end
	 else 
	 begin 
	 delete from repeatedCustomers where   CustomerID=@id
	 delete from Customers where  CustomerID=@id
	 end
	  end

exec CustomerBill '11C'
-------------------------
	  create procedure repetitionCustomercontrol @id varchar(20)
	as begin
	 declare @name varchar(20);
	   declare @med varchar(20)
	    declare @qu float;
		declare @pr float;
	   select @name=CustomerName,@med=Productid,@qu=Quantity,@pr=price from
	   Customers
	   where CustomerID=@id
	   select @name
	   insert into [orgCustomers]
	 values (@id,@name,@med,@qu,@pr)
	end
exec repetitionCustomercontrol  '11C'