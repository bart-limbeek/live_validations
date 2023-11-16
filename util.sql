create or replace package util as
    procedure return_message(
        p_message in varchar2
    ,   p_page_item in varchar2
    ,   p_validation_type in varchar2
    ,   p_page_item_error in varchar2
    );
end util;
/