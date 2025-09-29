function scr_game_text(_text_id) {
    switch(_text_id) {
        case "guard_1": 
            global.in_dialogue = true;
            scr_text("Hello There!");
            scr_text("I'm The Guard!");
            scr_text("If you wanna pass the gate, you have to answer my question!");
            scr_text("What is 7 x 8?");
            scr_option("56", "guard_1-correct");
            scr_option("65", "guard_1-incorrect");
        break;
        
        case "guard_1-correct":
            global.in_dialogue = true;
            scr_text("NICE!");
            scr_text("You may Pass!");
            global.points += 1;
            with (obj_gate) {
                quest_done = true;
            }
            global.in_dialogue = false; // ✅ end dialogue
        break;
        
        case "guard_1-incorrect":
            global.in_dialogue = true;
            scr_text("Too bad!");
            scr_text("You better study up your math!");
            scr_text("Try again if you already know the answer!");
            global.in_dialogue = false; // ✅ end dialogue
        break;
        
        case "guard_2":
            global.in_dialogue = true;
            scr_text("Hmmmmm......");
            scr_text("I see that the first guard's question was way too easy for you!");
            scr_text("Figure out this then!");
            scr_text("What is x for 3x + 5 = 11!");
            scr_option("2", "guard_2-correct");
            scr_option("13", "guard_2-incorrect");
        break;
        
        case "guard_2-correct":
            global.in_dialogue = true;
            scr_text("Wow!!!!");
            scr_text("You're so smart!");
            scr_text("You may pass the gate!");
            global.points += 5;
            with (obj_gate) {
                quest_done = true;
            }
            global.in_dialogue = false; // ✅ end dialogue
        break;
        
        case "guard_2-incorrect":
            global.in_dialogue = true;
            scr_text("Haha!");
            scr_text("You're Not that smart after all!");
            scr_text("Try again later!");
            global.in_dialogue = false; // ✅ end dialogue
        break;
        
        case "guard_3":
            global.in_dialogue = true;
            scr_text("HAHAHAHAHAHHAHAHAHAHAHA!");
            scr_text("Never thought that you would make it this far!");
            scr_text("Now answer This!!!!");
            scr_text("From 10 people, 3 will be picked by random, how many ways are there to pick them?");
            scr_option("90", "guard_3-incorrect");
            scr_option("120", "guard_3-correct");
        break;
        
        case "guard_3-incorrect":
            global.in_dialogue = true;
            scr_text("WRONGGG!!!!");
            scr_text("Come back when you've already figured it out!");
            global.in_dialogue = false; // ✅ end dialogue
        break;
        
        case "guard_3-correct":
            global.in_dialogue = true;
            scr_text("WOWWWWW!");
            scr_text("YOU ARE CORRECT");
            scr_text("Congratulations!, now you may pass this final gate!");
            global.points += 10;
            with (obj_gate) {
                quest_done = true;
            }
            global.in_dialogue = false; // ✅ end dialogue
        break;
        
        case "ai_chat":
            global.in_dialogue = true;
            instance_destroy();
            with (instance_create_depth(0, 0, -9999, obj_textbox)) {
                is_ai_chat = true;
                scr_text("Hello! Ask me anything and I'll try to help. Type your message and press Enter.");
                scr_option("Done", "ai_chat - done");
            }
        break;
        
        case "ai_chat - done":
            scr_text("Thank you for using my service!");
            global.in_dialogue = false; // ✅ end dialogue
        break;
    }
}
