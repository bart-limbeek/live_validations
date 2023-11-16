create or replace package package_p3 as
    procedure validate_item(
        p_page_item_name in varchar2
    ,   p_validation_type in varchar2
    );

    function validate
    return varchar2;
end package_p3;
/