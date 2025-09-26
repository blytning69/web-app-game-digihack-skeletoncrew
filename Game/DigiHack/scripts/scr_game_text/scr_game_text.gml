function scr_game_text(_text_id){
    
    switch(_text_id) {
        case "guard": 
            scr_text("Hello Fellow Citizen!");
            scr_text("I'm The Guard!");
            scr_option("Hello!", "guard - yes");
            scr_option("Fuck OFF!", "guard - no");
            scr_option("Chat with AI", "ai_chat");  // NEW OPTION
        break;
        
        case "guard - yes" :
            scr_text("Letsgooo!");
            with (obj_gate) {
                quest_done = true;
            }
        break;
        
        case "guard - no" :
            scr_text("GET OUT!");
            with (obj_gate) {
                quest_done = true;
            }
        break;
        
        // NEW AI CHAT CASE
        case "ai_chat":
            instance_destroy(); // Destroy current textbox
            create_ai_chatbot("AI Assistant: Hello! Ask me anything and I'll try to help. Type your message and press Enter.");
        break;
    }
}