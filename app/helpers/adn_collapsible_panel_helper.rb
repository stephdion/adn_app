module AdnCollapsiblePanelHelper

def ADN_Collapsible_Panel_Header(id_name, title)
	link_to(fa_icon("plus-square", class: "icon-plus"), 'javascript:;', {"onclick" => "DisplayTable('#{id_name}');", "id" => "show" + id_name}) +
    link_to(fa_icon("minus-square", class: "icon-plus"), 'javascript:;', {"onclick" => "HideTable('#{id_name}');", "id" => "hide" + id_name, "style" => "display:none;"}) +
    raw("<adnCollapsiblePanelHeader class='title-row-evaluation'>") + title + raw("</adnCollapsiblePanelHeader>") +
    tag("div", {"id" => id_name, "class" => "collapsible_trigger", "style" =>"z-index: 4; background-color: white;"}, true, true)
end

def ADN_Collapsible_Panel_Footer()
	raw("</div></br>")
end

end
