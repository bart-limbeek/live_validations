create or replace package body package_p3
as
    procedure validate_item(
        p_page_item_name in varchar2
    ,   p_validation_type in varchar2
    )
    is
        l_message varchar2(400 char);
        l_page_item_error varchar2(400 char);
        l_item varchar2(4000 char);
        l_date varchar2(20 char);
        l_station_departure varchar2(100 char);
        l_station_arrival varchar2(100 char);
    begin
        l_item := apex_util.get_session_state(p_item => p_page_item_name);
        l_page_item_error := apex_util.get_session_state(p_item => 'P0_VALIDATE_ITEM_ERROR');
        case
            when p_page_item_name = 'P3_TRAVEL_DATE' then
                if l_item is null then
                    l_message := 'Travel date cannot be empty';
                elsif validate_conversion(l_item as date, 'dd-mm-yyyy') = 0 then
                    l_message := 'Invalid date format';
                elsif l_item > sysdate then
                    l_message := 'Date cannot be in the future';
                end if;
            when p_page_item_name in ('P3_STATION_DEPARTURE','P3_STATION_ARRIVAL') then
                l_station_departure := apex_util.get_session_state(p_item => 'P3_STATION_DEPARTURE');
                l_station_arrival := apex_util.get_session_state(p_item => 'P3_STATION_ARRIVAL');
                if l_item is null then
                    l_message := 'Station cannot be empty';
                elsif l_item not in ('Heathrow','Reading','Waterloo','Paddington','King''s Cross','St Pancras International','Liverpool Street','Fenchurch Street','London Bridge','Victoria') then
                    l_message := 'This is not a valid station';
                elsif l_station_departure = l_station_arrival then
                    l_message := 'Station of departure and station of arrival could not be the same';
                end if;
            when p_page_item_name in ('P3_DEPARTURE_TIME_EXPECTED','P3_DEPARTURE_TIME_ACTUAL','P3_ARRIVAL_TIME_EXPECTED','P3_ARRIVAL_TIME_ACTUAL') then
                if validate_conversion(l_item as date, 'HH24:MI') = 0 then
                    l_message := 'Format has to be written as [HH24:MI]';
                elsif p_page_item_name in ('P3_DEPARTURE_TIME_EXPECTED','P3_ARRIVAL_TIME_EXPECTED') and l_item is null then
                    l_message := 'Time cannot be empty';
                elsif not regexp_like(l_item,'\d{1,2}:\d{2}') then
                    l_message := 'Format has to be written as [HH24:MI]';
                end if;
            when p_page_item_name = 'P3_SUBMITTER' then
                if l_item is null then
                    l_message := 'Name cannot be empty';
                end if;
            when p_page_item_name = 'P3_EMAIL_ADDRESS' then
                if l_item is null then
                    l_message := 'Email address cannot be empty';
                end if;
            else
                null;
        end case;
        --
        util.return_message(
            p_message => l_message
        ,   p_page_item => p_page_item_name
        ,   p_validation_type => p_validation_type
        ,   p_page_item_error => l_page_item_error
        );
    end validate_item;

    function validate
    return varchar2
    is
        type varray_type is varying array(50) of varchar2(50);
        varray_items varray_type;
    begin
        varray_items := varray_type(
            'P3_TRAVEL_DATE'
        ,   'P3_STATION_DEPARTURE'
        ,   'P3_STATION_ARRIVAL'
        ,   'P3_DEPARTURE_TIME_EXPECTED'
        ,   'P3_DEPARTURE_TIME_ACTUAL'
        ,   'P3_ARRIVAL_TIME_EXPECTED'
        ,   'P3_ARRIVAL_TIME_ACTUAL'
        ,   'P3_SUBMITTER'
        ,   'P3_EMAIL_ADDRESS'
        );
        for i in 1 .. varray_items.count loop
            validate_item(
                p_page_item_name => varray_items(i)
            ,   p_validation_type => 'SUBMIT'
            );
        end loop;
        --
        return null;
    end validate;
end package_p3;
/