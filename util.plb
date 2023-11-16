create or replace package body util as
    procedure return_message(
        p_message in varchar2
    ,   p_page_item in varchar2
    ,   p_validation_type in varchar2
    ,   p_page_item_error in varchar2
    )
    is
        l_validate_message varchar2(400);
        l_validate_item_error varchar2(400);
    begin
        case p_validation_type
            when 'LIVE' then
                if p_page_item_error is null or p_page_item_error = p_page_item then
                    if p_page_item_error is null then
                        l_validate_message := p_message;
                        if p_message is not null then
                            l_validate_item_error := p_page_item;
                        end if;
                    end if;
                    apex_util.set_session_state(
                        p_name => 'P0_VALIDATE_ITEM'
                    ,   p_value => p_page_item
                    );
                    apex_util.set_session_state(
                        p_name => 'P0_VALIDATE_MESSAGE'
                    ,   p_value => l_validate_message
                    );
                    apex_util.set_session_state(
                        p_name => 'P0_VALIDATE_ITEM_ERROR'
                    ,   p_value => l_validate_item_error
                    );
                end if;
            when 'SUBMIT' then
                if p_message is not null then
                    apex_error.add_error(
                        p_message => p_message
                    ,   p_display_location => apex_error.c_inline_with_field_and_notif
                    ,   p_page_item_name => p_page_item
                    );
                end if;
            else
                null;
        end case;
    end return_message;
end util;
/