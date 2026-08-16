#!/system/bin/sh

# =========================================================
# Winter Hide
# Dynamic User Profile
#
# by Xv2Ice
# Thanks MRX7014 for using his own S26U Spoofer
# =========================================================

AUTOMOUNT=true
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

# =========================================================
# Directories
# =========================================================

SPOOFER_ONEUI_DIR="$MODPATH/SpoofersOneUI"
SPOOFER_NONONEUI_DIR="$MODPATH/SpoofersNonOneUI"
FONT_DIR="$MODPATH/Fonts"

FLOATING_FEATURE="/system/etc/floating_feature.xml"
MOD_FLOATING_FEATURE="$MODPATH/system/etc/floating_feature.xml"

# =========================================================
# State
# =========================================================

USER_TYPE=""

SPOOF_DONE=0
BLUR_DONE=0
AI_DONE=0
FONT_DONE=0

SPOOF_SELECTED=""
FONT_SELECTED=""

BLUR_SELECTED="Keep As Base"
AI_SELECTED="Keep As Base"

EXIT_INSTALL=0

# =========================================================
# Dynamic Data
# =========================================================

SPOOFER_DIR=""
SPOOFERS=""
SPOOFER_COUNT=0

FONTS=""
FONT_COUNT=0

# =========================================================
# Save State
# =========================================================

save_state() {

    if [ -n "$USER_TYPE" ]; then
        printf '%s\n' "$USER_TYPE" > "$MODPATH/user_type"
    fi

    if [ -n "$SPOOF_SELECTED" ]; then
        printf '%s\n' "$SPOOF_SELECTED" > "$MODPATH/spoofer_name"
    fi

    if [ -n "$FONT_SELECTED" ]; then
        printf '%s\n' "$FONT_SELECTED" > "$MODPATH/font_name"
    fi

    if [ -n "$BLUR_SELECTED" ]; then
        printf '%s\n' "$BLUR_SELECTED" > "$MODPATH/blur_state"
    fi

    if [ -n "$AI_SELECTED" ]; then
        printf '%s\n' "$AI_SELECTED" > "$MODPATH/ai_state"
    fi

    chmod 0644 \
        "$MODPATH/user_type" \
        "$MODPATH/spoofer_name" \
        "$MODPATH/font_name" \
        "$MODPATH/blur_state" \
        "$MODPATH/ai_state" \
        2>/dev/null
}

# =========================================================
# Visual spacing
# =========================================================

print_space() {

    i=0

    while [ "$i" -lt 50 ]; do
        ui_print " "
        i=$((i + 1))
    done
}

# =========================================================
# Volume Key Handler
#
# VOL+ = Next / Confirm
# VOL- = Select / Change / Exit
# =========================================================

wait_key() {

    KEY_RESULT=""

    while true; do

        LINE="$(getevent -qlc 1 2>/dev/null)"

        case "$LINE" in

            *KEY_VOLUMEUP*)

                KEY_RESULT="UP"
                sleep 1
                return 0
                ;;

            *KEY_VOLUMEDOWN*)

                KEY_RESULT="DOWN"
                sleep 1
                return 0
                ;;

        esac

    done
}

# =========================================================
# Load Dynamic Spoofers
#
# Every folder containing system.prop is valid.
#
# Structure:
#
# SpoofersOneUI/
# ├── S26Ultra/
# │   └── system.prop
# └── S25Ultra/
#     └── system.prop
#
# Same for SpoofersNonOneUI.
# =========================================================

load_spoofers() {

    SPOOFERS=""
    SPOOFER_COUNT=0

    if [ ! -d "$SPOOFER_DIR" ]; then
        return 1
    fi

    for DIR in "$SPOOFER_DIR"/*; do

        [ -d "$DIR" ] || continue

        NAME="$(basename "$DIR")"

        if [ -f "$DIR/system.prop" ]; then

            if [ -z "$SPOOFERS" ]; then
                SPOOFERS="$NAME"
            else
                SPOOFERS="$SPOOFERS
$NAME"
            fi

        fi

    done

    if [ -z "$SPOOFERS" ]; then
        return 1
    fi

    SPOOFERS="$(printf '%s\n' "$SPOOFERS" | LC_ALL=C sort)"

    SPOOFER_COUNT="$(printf '%s\n' "$SPOOFERS" | wc -l)"

    return 0
}

# =========================================================
# Get Spoofer
# =========================================================

get_spoofer() {

    printf '%s\n' "$SPOOFERS" | sed -n "${1}p"
}

# =========================================================
# Load Dynamic Fonts
#
# Roboto-Regular.ttf = REQUIRED
# NotoColorEmoji.ttf = OPTIONAL
# OneUISans-VF.ttf = OPTIONAL for OneUI
# =========================================================

load_fonts() {

    FONTS=""
    FONT_COUNT=0

    if [ ! -d "$FONT_DIR" ]; then
        return 0
    fi

    for DIR in "$FONT_DIR"/*; do

        [ -d "$DIR" ] || continue

        NAME="$(basename "$DIR")"

        if [ -f "$DIR/Roboto-Regular.ttf" ]; then

            if [ -z "$FONTS" ]; then
                FONTS="$NAME"
            else
                FONTS="$FONTS
$NAME"
            fi

        fi

    done

    if [ -z "$FONTS" ]; then
        return 0
    fi

    FONTS="$(printf '%s\n' "$FONTS" | LC_ALL=C sort)"

    FONT_COUNT="$(printf '%s\n' "$FONTS" | wc -l)"

    return 0
}

# =========================================================
# Get Font
# =========================================================

get_font() {

    printf '%s\n' "$FONTS" | sed -n "${1}p"
}

# =========================================================
# USER TYPE MENU
# =========================================================

user_type_menu() {

    INDEX=1

    while true; do

        print_space

        ui_print "================================"
        ui_print "        WINTER HIDE"
        ui_print "================================"
        ui_print " "
        ui_print "What type of user are you?"
        ui_print " "

        case "$INDEX" in

            1)

                ui_print "> OneUI User"
                ui_print "  Non OneUI User"
                ;;

            2)

                ui_print "  OneUI User"
                ui_print "> Non OneUI User"
                ;;

        esac

        ui_print " "
        ui_print "VOL+ = Next"
        ui_print "VOL- = Select"

        wait_key

        case "$KEY_RESULT" in

            UP)

                INDEX=$((INDEX + 1))

                if [ "$INDEX" -gt 2 ]; then
                    INDEX=1
                fi

                ;;

            DOWN)

                case "$INDEX" in

                    1)
                        USER_TYPE="ONEUI"
                        ;;

                    2)
                        USER_TYPE="NONONEUI"
                        ;;

                esac

                user_type_confirm

                return 0
                ;;

        esac

    done
}

# =========================================================
# USER TYPE CONFIRM
# =========================================================

user_type_confirm() {

    while true; do

        print_space

        ui_print "================================"
        ui_print "        WINTER HIDE"
        ui_print "================================"
        ui_print " "
        ui_print "You selected:"
        ui_print " "

        case "$USER_TYPE" in

            ONEUI)

                ui_print "        OneUI User"
                ui_print " "
                ui_print "Available mods:"
                ui_print " "
                ui_print "• Spoof Your Device"
                ui_print "• Live Blur"
                ui_print "• AI"
                ui_print "• Font Changer"
                ;;

            NONONEUI)

                ui_print "      Non OneUI User"
                ui_print " "
                ui_print "Available mods:"
                ui_print " "
                ui_print "• Spoof Your Device"
                ui_print "• Font Changer"
                ui_print " "
                ui_print "Live Blur and AI will not"
                ui_print "be available."
                ;;

        esac

        ui_print " "
        ui_print "VOL+ = Confirm"
        ui_print "VOL- = Change"

        wait_key

        case "$KEY_RESULT" in

            UP)

                save_state
                return 0
                ;;

            DOWN)

                user_type_menu
                return 0
                ;;

        esac

    done
}

# =========================================================
# Configure User Profile
# =========================================================

configure_user_profile() {

    case "$USER_TYPE" in

        ONEUI)

            SPOOFER_DIR="$SPOOFER_ONEUI_DIR"
            ;;

        NONONEUI)

            SPOOFER_DIR="$SPOOFER_NONONEUI_DIR"
            ;;

        *)

            abort "! Invalid user type!"
            ;;

    esac

    if [ ! -d "$SPOOFER_DIR" ]; then

        print_space

        ui_print "================================"
        ui_print "        WINTER HIDE"
        ui_print "================================"
        ui_print " "
        ui_print "! Required spoofer directory"
        ui_print "  was not found."
        ui_print " "

        case "$USER_TYPE" in

            ONEUI)

                ui_print "Missing:"
                ui_print "SpoofersOneUI"
                ;;

            NONONEUI)

                ui_print "Missing:"
                ui_print "SpoofersNonOneUI"
                ;;

        esac

        ui_print " "

        abort "! Cannot continue without spoofers."
    fi

    if ! load_spoofers; then
        abort "! No valid spoofers found for this profile!"
    fi

    load_fonts
}

# =========================================================
# Prepare floating_feature.xml
# =========================================================

prepare_floating_feature() {

    if [ -f "$MOD_FLOATING_FEATURE" ]; then
        return 0
    fi

    if [ ! -f "$FLOATING_FEATURE" ]; then
        abort "! /system/etc/floating_feature.xml not found!"
    fi

    mkdir -p "$MODPATH/system/etc"

    cp -f \
        "$FLOATING_FEATURE" \
        "$MOD_FLOATING_FEATURE"

    if [ ! -f "$MOD_FLOATING_FEATURE" ]; then
        abort "! Failed to copy floating_feature.xml!"
    fi

    chmod 0644 "$MOD_FLOATING_FEATURE"
}

# =========================================================
# Modify floating_feature.xml
# =========================================================

set_floating_feature() {

    TAG="$1"
    VALUE="$2"

    prepare_floating_feature

    if grep -q "<$TAG>" "$MOD_FLOATING_FEATURE"; then

        sed -i \
            "s#<$TAG>[^<]*</$TAG>#<$TAG>$VALUE</$TAG>#g" \
            "$MOD_FLOATING_FEATURE"

    else

        if grep -q "</resources>" "$MOD_FLOATING_FEATURE"; then

            sed -i \
                "s#</resources>#    <$TAG>$VALUE</$TAG>\n</resources>#" \
                "$MOD_FLOATING_FEATURE"

        else

            printf '\n    <%s>%s</%s>\n' \
                "$TAG" \
                "$VALUE" \
                "$TAG" \
                >> "$MOD_FLOATING_FEATURE"

        fi

    fi

    chmod 0644 "$MOD_FLOATING_FEATURE"
}

# =========================================================
# Install Spoofer
#
# IMPORTANT:
#
# Both OneUI and Non-OneUI spoofers are installed as:
#
# $MODPATH/system.prop
#
# This means the selected properties are applied through
# Magisk/KSU system.prop automatically.
# =========================================================

install_spoofer() {

    SELECTED="$1"

    SPOOFER_PATH="$SPOOFER_DIR/$SELECTED"
    SOURCE="$SPOOFER_PATH/system.prop"
    DEST="$MODPATH/system.prop"

    # -----------------------------------------------------
    # Validate selected spoofer
    # -----------------------------------------------------

    if [ ! -d "$SPOOFER_PATH" ]; then
        abort "! Selected spoofer directory not found!"
    fi

    if [ ! -f "$SOURCE" ]; then
        abort "! system.prop not found for $SELECTED!"
    fi

    # -----------------------------------------------------
    # Validate system.prop is not empty
    # -----------------------------------------------------

    if [ ! -s "$SOURCE" ]; then
        abort "! system.prop for $SELECTED is empty!"
    fi

    # -----------------------------------------------------
    # Remove previous spoofer
    # -----------------------------------------------------

    rm -f "$DEST"

    # -----------------------------------------------------
    # Install selected system.prop
    # -----------------------------------------------------

    mkdir -p "$MODPATH"

    cp -f \
        "$SOURCE" \
        "$DEST"

    if [ ! -f "$DEST" ]; then
        abort "! Failed to install spoofer system.prop!"
    fi

    # -----------------------------------------------------
    # Permissions
    # -----------------------------------------------------

    chmod 0644 "$DEST"

    # -----------------------------------------------------
    # Save state
    # -----------------------------------------------------

    SPOOF_SELECTED="$SELECTED"

    printf '%s\n' "$SPOOF_SELECTED" \
        > "$MODPATH/spoofer_name"

    save_state

    ui_print " "
    ui_print "✓ Spoofer installed"
    ui_print "✓ system.prop created"
    ui_print " "
}

# =========================================================
# Install Font Pack
# =========================================================

install_font() {

    SELECTED="$1"

    FONT_SOURCE_DIR="$FONT_DIR/$SELECTED"
    FONT_DEST_DIR="$MODPATH/system/fonts"

    if [ ! -d "$FONT_SOURCE_DIR" ]; then
        abort "! Selected font directory not found!"
    fi

    if [ ! -f "$FONT_SOURCE_DIR/Roboto-Regular.ttf" ]; then
        abort "! Roboto-Regular.ttf is missing!"
    fi

    mkdir -p "$FONT_DEST_DIR"

    # -----------------------------------------------------
    # Clean previous font files
    # -----------------------------------------------------

    rm -f "$FONT_DEST_DIR/Roboto-Regular.ttf"
    rm -f "$FONT_DEST_DIR/NotoColorEmoji.ttf"
    rm -f "$FONT_DEST_DIR/OneUISans-VF.ttf"

    # -----------------------------------------------------
    # Roboto
    # -----------------------------------------------------

    cp -f \
        "$FONT_SOURCE_DIR/Roboto-Regular.ttf" \
        "$FONT_DEST_DIR/Roboto-Regular.ttf"

    if [ ! -f "$FONT_DEST_DIR/Roboto-Regular.ttf" ]; then
        abort "! Failed to install Roboto-Regular.ttf!"
    fi

    # -----------------------------------------------------
    # Emoji
    # -----------------------------------------------------

    if [ -f "$FONT_SOURCE_DIR/NotoColorEmoji.ttf" ]; then

        cp -f \
            "$FONT_SOURCE_DIR/NotoColorEmoji.ttf" \
            "$FONT_DEST_DIR/NotoColorEmoji.ttf"

    fi

    # -----------------------------------------------------
    # OneUI Sans
    # -----------------------------------------------------

    if [ "$USER_TYPE" = "ONEUI" ]; then

        if [ -f "$FONT_SOURCE_DIR/OneUISans-VF.ttf" ]; then

            cp -f \
                "$FONT_SOURCE_DIR/OneUISans-VF.ttf" \
                "$FONT_DEST_DIR/OneUISans-VF.ttf"

        fi

    fi

    chmod 0644 "$FONT_DEST_DIR"/*.ttf 2>/dev/null

    FONT_SELECTED="$SELECTED"

    printf '%s\n' "$FONT_SELECTED" \
        > "$MODPATH/font_name"

    save_state
}

# =========================================================
# POST MOD MENU
# =========================================================

post_mod_menu() {

    # -----------------------------------------------------
    # OneUI completion
    # -----------------------------------------------------

    if [ "$USER_TYPE" = "ONEUI" ]; then

        if [ "$SPOOF_DONE" -eq 1 ] &&
           [ "$BLUR_DONE" -eq 1 ] &&
           [ "$AI_DONE" -eq 1 ] &&
           [ "$FONT_DONE" -eq 1 ]; then

            save_state

            print_space

            ui_print "================================"
            ui_print "        WINTER HIDE"
            ui_print "================================"
            ui_print " "
            ui_print "All available mods are configured."
            ui_print " "
            ui_print "VOL- = Save & Exit"
            ui_print " "

            while true; do

                wait_key

                if [ "$KEY_RESULT" = "DOWN" ]; then

                    EXIT_INSTALL=1
                    return 0

                fi

            done

        fi

    fi

    # -----------------------------------------------------
    # Non-OneUI completion
    # -----------------------------------------------------

    if [ "$USER_TYPE" = "NONONEUI" ]; then

        if [ "$SPOOF_DONE" -eq 1 ] &&
           [ "$FONT_DONE" -eq 1 ]; then

            save_state

            print_space

            ui_print "================================"
            ui_print "        WINTER HIDE"
            ui_print "================================"
            ui_print " "
            ui_print "All available mods are configured."
            ui_print " "
            ui_print "VOL- = Save & Exit"
            ui_print " "

            while true; do

                wait_key

                if [ "$KEY_RESULT" = "DOWN" ]; then

                    EXIT_INSTALL=1
                    return 0

                fi

            done

        fi

    fi

    # -----------------------------------------------------
    # More mods / Exit
    # -----------------------------------------------------

    print_space

    ui_print "================================"
    ui_print "        WINTER HIDE"
    ui_print "================================"
    ui_print " "
    ui_print "Current changes are ready."
    ui_print " "
    ui_print "VOL+ = Mod Something Else"
    ui_print "VOL- = Save Changes & Exit"
    ui_print " "

    while true; do

        wait_key

        case "$KEY_RESULT" in

            UP)

                return 1
                ;;

            DOWN)

                save_state

                EXIT_INSTALL=1
                return 0
                ;;

        esac

    done
}

# =========================================================
# SPOOFER MENU
# =========================================================

spoof_menu() {

    INDEX=1

    while true; do

        print_space

        ui_print "================================"
        ui_print "       SPOOF YOUR DEVICE"
        ui_print "================================"
        ui_print " "

        case "$USER_TYPE" in

            ONEUI)
                ui_print "Spoofers - OneUI"
                ;;

            NONONEUI)
                ui_print "Spoofers - Non OneUI"
                ;;

        esac

        ui_print " "
        ui_print "Detected $SPOOFER_COUNT valid spoofers."
        ui_print " "

        i=1

        while [ "$i" -le "$SPOOFER_COUNT" ]; do

            NAME="$(get_spoofer "$i")"

            if [ "$i" -eq "$INDEX" ]; then
                ui_print "> $NAME"
            else
                ui_print "  $NAME"
            fi

            i=$((i + 1))

        done

        ui_print " "
        ui_print "VOL+ = Next"
        ui_print "VOL- = Select"

        wait_key

        case "$KEY_RESULT" in

            UP)

                INDEX=$((INDEX + 1))

                if [ "$INDEX" -gt "$SPOOFER_COUNT" ]; then
                    INDEX=1
                fi

                ;;

            DOWN)

                SPOOF_SELECTED="$(get_spoofer "$INDEX")"

                spoof_confirm

                return 0
                ;;

        esac

    done
}

# =========================================================
# SPOOFER CONFIRM
# =========================================================

spoof_confirm() {

    while true; do

        print_space

        ui_print "================================"
        ui_print "       SPOOF YOUR DEVICE"
        ui_print "================================"
        ui_print " "
        ui_print "You selected:"
        ui_print " "
        ui_print "        $SPOOF_SELECTED"
        ui_print " "

        ui_print "Please make sure:"
        ui_print " "
        ui_print "• You are not running a module that"
        ui_print "  modifies build.prop."
        ui_print " "
        ui_print "• Make sure your ROM does not spoof"
        ui_print "  anything by itself, like UN1CA."
        ui_print " "
        ui_print "• Also use NoMount Module."
        ui_print " "
        ui_print "VOL+ = Confirm"
        ui_print "VOL- = Change"

        wait_key

        case "$KEY_RESULT" in

            UP)

                install_spoofer "$SPOOF_SELECTED"

                SPOOF_DONE=1

                save_state

                post_mod_menu

                return 0
                ;;

            DOWN)

                return 0
                ;;

        esac

    done
}

# =========================================================
# LIVE BLUR MENU
# =========================================================

blur_menu() {

    INDEX=1

    while true; do

        print_space

        ui_print "================================"
        ui_print "          LIVE BLUR"
        ui_print "================================"
        ui_print " "
        ui_print "Choose Live Blur mode:"
        ui_print " "

        case "$INDEX" in

            1)

                ui_print "> Enable"
                ui_print "  Disable"
                ui_print "  Keep As Base"
                ;;

            2)

                ui_print "  Enable"
                ui_print "> Disable"
                ui_print "  Keep As Base"
                ;;

            3)

                ui_print "  Enable"
                ui_print "  Disable"
                ui_print "> Keep As Base"
                ;;

        esac

        ui_print " "
        ui_print "Please make sure:"
        ui_print " "
        ui_print "• You are not running a module that"
        ui_print "  does the same job on floating feature."
        ui_print " "
        ui_print "• Make sure your base supports Live Blur."
        ui_print " "
        ui_print "• Also use NoMount Module."
        ui_print " "
        ui_print "VOL+ = Next"
        ui_print "VOL- = Select"

        wait_key

        case "$KEY_RESULT" in

            UP)

                INDEX=$((INDEX + 1))

                if [ "$INDEX" -gt 3 ]; then
                    INDEX=1
                fi

                ;;

            DOWN)

                case "$INDEX" in

                    1)

                        blur_confirm "Enable" "TRUE"
                        return 0
                        ;;

                    2)

                        blur_confirm "Disable" "FALSE"
                        return 0
                        ;;

                    3)

                        BLUR_SELECTED="Keep As Base"
                        BLUR_DONE=1

                        save_state

                        post_mod_menu

                        return 0
                        ;;

                esac

                ;;

        esac

    done
}

# =========================================================
# LIVE BLUR CONFIRM
# =========================================================

blur_confirm() {

    CHOICE="$1"
    VALUE="$2"

    while true; do

        print_space

        ui_print "================================"
        ui_print "          LIVE BLUR"
        ui_print "================================"
        ui_print " "
        ui_print "You selected:"
        ui_print " "
        ui_print "        $CHOICE"
        ui_print " "
        ui_print "VOL+ = Confirm"
        ui_print "VOL- = Change"

        wait_key

        case "$KEY_RESULT" in

            UP)

                set_floating_feature \
                    "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_3D_SURFACE_TRANSITION_FLAG" \
                    "$VALUE"

                BLUR_SELECTED="$CHOICE"
                BLUR_DONE=1

                save_state

                post_mod_menu

                return 0
                ;;

            DOWN)

                return 0
                ;;

        esac

    done
}

# =========================================================
# AI MENU
# =========================================================

ai_menu() {

    INDEX=1

    while true; do

        print_space

        ui_print "================================"
        ui_print "             AI"
        ui_print "================================"
        ui_print " "
        ui_print "Choose Native AI mode:"
        ui_print " "

        case "$INDEX" in

            1)

                ui_print "> Enable"
                ui_print "  Disable"
                ui_print "  Keep As Base"
                ;;

            2)

                ui_print "  Enable"
                ui_print "> Disable"
                ui_print "  Keep As Base"
                ;;

            3)

                ui_print "  Enable"
                ui_print "  Disable"
                ui_print "> Keep As Base"
                ;;

        esac

        ui_print " "
        ui_print "Please make sure:"
        ui_print " "
        ui_print "• You are not running a module that"
        ui_print "  does the same job on floating feature."
        ui_print " "
        ui_print "• Make sure your base supports AI."
        ui_print " "
        ui_print "• Also use NoMount Module."
        ui_print " "
        ui_print "VOL+ = Next"
        ui_print "VOL- = Select"

        wait_key

        case "$KEY_RESULT" in

            UP)

                INDEX=$((INDEX + 1))

                if [ "$INDEX" -gt 3 ]; then
                    INDEX=1
                fi

                ;;

            DOWN)

                case "$INDEX" in

                    1)

                        ai_confirm "Enable" "FALSE"
                        return 0
                        ;;

                    2)

                        ai_confirm "Disable" "TRUE"
                        return 0
                        ;;

                    3)

                        AI_SELECTED="Keep As Base"
                        AI_DONE=1

                        save_state

                        post_mod_menu

                        return 0
                        ;;

                esac

                ;;

        esac

    done
}

# =========================================================
# AI CONFIRM
# =========================================================

ai_confirm() {

    CHOICE="$1"
    VALUE="$2"

    while true; do

        print_space

        ui_print "================================"
        ui_print "             AI"
        ui_print "================================"
        ui_print " "
        ui_print "You selected:"
        ui_print " "
        ui_print "        $CHOICE"
        ui_print " "
        ui_print "VOL+ = Confirm"
        ui_print "VOL- = Change"

        wait_key

        case "$KEY_RESULT" in

            UP)

                set_floating_feature \
                    "SEC_FLOATING_FEATURE_COMMON_DISABLE_NATIVE_AI" \
                    "$VALUE"

                AI_SELECTED="$CHOICE"
                AI_DONE=1

                save_state

                post_mod_menu

                return 0
                ;;

            DOWN)

                return 0
                ;;

        esac

    done
}

# =========================================================
# FONT MENU
# =========================================================

font_menu() {

    if [ "$FONT_COUNT" -eq 0 ]; then

        print_space

        ui_print "================================"
        ui_print "         FONT CHANGER"
        ui_print "================================"
        ui_print " "
        ui_print "No valid fonts found."
        ui_print " "
        ui_print "A valid Font Pack must contain:"
        ui_print " "
        ui_print "Roboto-Regular.ttf"
        ui_print " "
        ui_print "VOL- = Back"
        ui_print " "

        while true; do

            wait_key

            if [ "$KEY_RESULT" = "DOWN" ]; then
                return 0
            fi

        done

    fi

    INDEX=1

    while true; do

        print_space

        ui_print "================================"
        ui_print "         FONT CHANGER"
        ui_print "================================"
        ui_print " "
        ui_print "Detected $FONT_COUNT valid font packs."
        ui_print " "
        ui_print "Available Fonts:"
        ui_print " "

        i=1

        while [ "$i" -le "$FONT_COUNT" ]; do

            NAME="$(get_font "$i")"

            if [ "$i" -eq "$INDEX" ]; then
                ui_print "> $NAME"
            else
                ui_print "  $NAME"
            fi

            i=$((i + 1))

        done

        ui_print " "
        ui_print "Please make sure:"
        ui_print " "
        ui_print "• You are not running a module that"
        ui_print "  does the same job on Fonts Folder."
        ui_print " "
        ui_print "• Make sure your base is OneUI 6 or higher."
        ui_print " "
        ui_print "• Also use NoMount Module."
        ui_print " "
        ui_print "VOL+ = Next"
        ui_print "VOL- = Select"

        wait_key

        case "$KEY_RESULT" in

            UP)

                INDEX=$((INDEX + 1))

                if [ "$INDEX" -gt "$FONT_COUNT" ]; then
                    INDEX=1
                fi

                ;;

            DOWN)

                FONT_SELECTED="$(get_font "$INDEX")"

                font_confirm

                return 0
                ;;

        esac

    done
}

# =========================================================
# FONT CONFIRM
# =========================================================

font_confirm() {

    while true; do

        print_space

        ui_print "================================"
        ui_print "         FONT CHANGER"
        ui_print "================================"
        ui_print " "
        ui_print "You selected:"
        ui_print " "
        ui_print "        $FONT_SELECTED"
        ui_print " "
        ui_print "Required:"
        ui_print "• Roboto-Regular.ttf"
        ui_print " "
        ui_print "Optional:"
        ui_print "• NotoColorEmoji.ttf"

        if [ "$USER_TYPE" = "ONEUI" ]; then
            ui_print "• OneUISans-VF.ttf"
        fi

        ui_print " "
        ui_print "Please make sure:"
        ui_print " "
        ui_print "• You are not running a module that"
        ui_print "  does the same job on Fonts Folder."
        ui_print " "
        ui_print "• Make sure your base is OneUI 6 or higher."
        ui_print " "
        ui_print "• Also use NoMount Module."
        ui_print " "
        ui_print "VOL+ = Confirm"
        ui_print "VOL- = Change"

        wait_key

        case "$KEY_RESULT" in

            UP)

                install_font "$FONT_SELECTED"

                FONT_DONE=1

                save_state

                post_mod_menu

                return 0
                ;;

            DOWN)

                return 0
                ;;

        esac

    done
}

# =========================================================
# MAIN MENU
# =========================================================

main_menu() {

    while true; do

        if [ "$EXIT_INSTALL" -eq 1 ]; then
            return 0
        fi

        COUNT=0

        OPT1=""
        OPT2=""
        OPT3=""
        OPT4=""

        # =================================================
        # ONEUI
        # =================================================

        if [ "$USER_TYPE" = "ONEUI" ]; then

            if [ "$SPOOF_DONE" -eq 0 ]; then

                COUNT=$((COUNT + 1))

                case "$COUNT" in
                    1) OPT1="SPOOF" ;;
                    2) OPT2="SPOOF" ;;
                    3) OPT3="SPOOF" ;;
                    4) OPT4="SPOOF" ;;
                esac

            fi

            if [ "$BLUR_DONE" -eq 0 ]; then

                COUNT=$((COUNT + 1))

                case "$COUNT" in
                    1) OPT1="BLUR" ;;
                    2) OPT2="BLUR" ;;
                    3) OPT3="BLUR" ;;
                    4) OPT4="BLUR" ;;
                esac

            fi

            if [ "$AI_DONE" -eq 0 ]; then

                COUNT=$((COUNT + 1))

                case "$COUNT" in
                    1) OPT1="AI" ;;
                    2) OPT2="AI" ;;
                    3) OPT3="AI" ;;
                    4) OPT4="AI" ;;
                esac

            fi

            if [ "$FONT_DONE" -eq 0 ] &&
               [ "$FONT_COUNT" -gt 0 ]; then

                COUNT=$((COUNT + 1))

                case "$COUNT" in
                    1) OPT1="FONT" ;;
                    2) OPT2="FONT" ;;
                    3) OPT3="FONT" ;;
                    4) OPT4="FONT" ;;
                esac

            fi

        fi

        # =================================================
        # NON-ONEUI
        # =================================================

        if [ "$USER_TYPE" = "NONONEUI" ]; then

            if [ "$SPOOF_DONE" -eq 0 ]; then

                COUNT=$((COUNT + 1))

                case "$COUNT" in
                    1) OPT1="SPOOF" ;;
                    2) OPT2="SPOOF" ;;
                esac

            fi

            if [ "$FONT_DONE" -eq 0 ] &&
               [ "$FONT_COUNT" -gt 0 ]; then

                COUNT=$((COUNT + 1))

                case "$COUNT" in
                    1) OPT1="FONT" ;;
                    2) OPT2="FONT" ;;
                esac

            fi

        fi

        # =================================================
        # EVERYTHING COMPLETED
        # =================================================

        if [ "$COUNT" -eq 0 ]; then

            save_state

            print_space

            ui_print "================================"
            ui_print "        WINTER HIDE"
            ui_print "================================"
            ui_print " "

            if [ "$USER_TYPE" = "ONEUI" ]; then

                ui_print "✓ Spoof Your Device"
                ui_print "✓ Live Blur"
                ui_print "✓ AI"
                ui_print "✓ Font Changer"

            else

                ui_print "✓ Spoof Your Device"
                ui_print "✓ Font Changer"

            fi

            ui_print " "
            ui_print "All available mods are configured."
            ui_print " "
            ui_print "VOL- = Save & Exit"
            ui_print " "

            while true; do

                wait_key

                if [ "$KEY_RESULT" = "DOWN" ]; then

                    EXIT_INSTALL=1
                    return 0

                fi

            done

        fi

        INDEX=1

        # =================================================
        # REMAINING MODS
        # =================================================

        while true; do

            if [ "$EXIT_INSTALL" -eq 1 ]; then
                return 0
            fi

            print_space

            ui_print "================================"
            ui_print "        WINTER HIDE"
            ui_print "================================"
            ui_print " "
            ui_print "What would you like to mod?"
            ui_print " "

            # =================================================
            # OPTION 1
            # =================================================

            case "$OPT1" in

                SPOOF)
                    [ "$INDEX" -eq 1 ] &&
                        ui_print "> Spoof Your Device" ||
                        ui_print "  Spoof Your Device"
                    ;;

                BLUR)
                    [ "$INDEX" -eq 1 ] &&
                        ui_print "> Enable/Disable Live Blur" ||
                        ui_print "  Enable/Disable Live Blur"
                    ;;

                AI)
                    [ "$INDEX" -eq 1 ] &&
                        ui_print "> Enable/Disable AI" ||
                        ui_print "  Enable/Disable AI"
                    ;;

                FONT)
                    [ "$INDEX" -eq 1 ] &&
                        ui_print "> Font Changer" ||
                        ui_print "  Font Changer"
                    ;;

            esac

            # =================================================
            # OPTION 2
            # =================================================

            if [ "$COUNT" -ge 2 ]; then

                case "$OPT2" in

                    SPOOF)
                        [ "$INDEX" -eq 2 ] &&
                            ui_print "> Spoof Your Device" ||
                            ui_print "  Spoof Your Device"
                        ;;

                    BLUR)
                        [ "$INDEX" -eq 2 ] &&
                            ui_print "> Enable/Disable Live Blur" ||
                            ui_print "  Enable/Disable Live Blur"
                        ;;

                    AI)
                        [ "$INDEX" -eq 2 ] &&
                            ui_print "> Enable/Disable AI" ||
                            ui_print "  Enable/Disable AI"
                        ;;

                    FONT)
                        [ "$INDEX" -eq 2 ] &&
                            ui_print "> Font Changer" ||
                            ui_print "  Font Changer"
                        ;;

                esac

            fi

            # =================================================
            # OPTION 3
            # =================================================

            if [ "$COUNT" -ge 3 ]; then

                case "$OPT3" in

                    SPOOF)
                        [ "$INDEX" -eq 3 ] &&
                            ui_print "> Spoof Your Device" ||
                            ui_print "  Spoof Your Device"
                        ;;

                    BLUR)
                        [ "$INDEX" -eq 3 ] &&
                            ui_print "> Enable/Disable Live Blur" ||
                            ui_print "  Enable/Disable Live Blur"
                        ;;

                    AI)
                        [ "$INDEX" -eq 3 ] &&
                            ui_print "> Enable/Disable AI" ||
                            ui_print "  Enable/Disable AI"
                        ;;

                    FONT)
                        [ "$INDEX" -eq 3 ] &&
                            ui_print "> Font Changer" ||
                            ui_print "  Font Changer"
                        ;;

                esac

            fi

            # =================================================
            # OPTION 4
            # =================================================

            if [ "$COUNT" -ge 4 ]; then

                case "$OPT4" in

                    SPOOF)
                        [ "$INDEX" -eq 4 ] &&
                            ui_print "> Spoof Your Device" ||
                            ui_print "  Spoof Your Device"
                        ;;

                    BLUR)
                        [ "$INDEX" -eq 4 ] &&
                            ui_print "> Enable/Disable Live Blur" ||
                            ui_print "  Enable/Disable Live Blur"
                        ;;

                    AI)
                        [ "$INDEX" -eq 4 ] &&
                            ui_print "> Enable/Disable AI" ||
                            ui_print "  Enable/Disable AI"
                        ;;

                    FONT)
                        [ "$INDEX" -eq 4 ] &&
                            ui_print "> Font Changer" ||
                            ui_print "  Font Changer"
                        ;;

                esac

            fi

            ui_print " "
            ui_print "VOL+ = Next"
            ui_print "VOL- = Select"

            wait_key

            # =================================================
            # NEXT
            # =================================================

            if [ "$KEY_RESULT" = "UP" ]; then

                INDEX=$((INDEX + 1))

                if [ "$INDEX" -gt "$COUNT" ]; then
                    INDEX=1
                fi

                continue

            fi

            # =================================================
            # SELECT
            # =================================================

            if [ "$KEY_RESULT" = "DOWN" ]; then

                case "$INDEX" in

                    1)
                        SELECTED_OPTION="$OPT1"
                        ;;

                    2)
                        SELECTED_OPTION="$OPT2"
                        ;;

                    3)
                        SELECTED_OPTION="$OPT3"
                        ;;

                    4)
                        SELECTED_OPTION="$OPT4"
                        ;;

                esac

                case "$SELECTED_OPTION" in

                    SPOOF)
                        spoof_menu
                        ;;

                    BLUR)
                        blur_menu
                        ;;

                    AI)
                        ai_menu
                        ;;

                    FONT)
                        font_menu
                        ;;

                esac

                if [ "$EXIT_INSTALL" -eq 1 ]; then
                    return 0
                fi

                break

            fi

        done

    done
}

# =========================================================
# START
# =========================================================

ui_print " "
ui_print "================================"
ui_print "      WELCOME TO WINTER HIDE"
ui_print "================================"
ui_print " "
ui_print "Dynamic User Profile System"
ui_print " "
ui_print "VOL+ = Next"
ui_print "VOL- = Select"
ui_print " "
ui_print "Starting..."
ui_print " "

sleep 3

# =========================================================
# Select User Type
# =========================================================

user_type_menu

# =========================================================
# Configure Selected Profile
# =========================================================

configure_user_profile

# =========================================================
# Profile Information
# =========================================================

print_space

ui_print "================================"
ui_print "        WINTER HIDE"
ui_print "================================"
ui_print " "

case "$USER_TYPE" in

    ONEUI)

        ui_print "Profile: OneUI User"
        ;;

    NONONEUI)

        ui_print "Profile: Non OneUI User"
        ;;

esac

ui_print " "
ui_print "Found $SPOOFER_COUNT available spoofers."

if [ "$FONT_COUNT" -gt 0 ]; then

    ui_print "Found $FONT_COUNT available font packs."

else

    ui_print "No valid font packs found."

fi

ui_print " "
ui_print "Loading..."
ui_print " "

sleep 2

# =========================================================
# Run
# =========================================================

main_menu

# =========================================================
# Final
# =========================================================

save_state

print_space

ui_print "================================"
ui_print "       WINTER HIDE DONE"
ui_print "================================"
ui_print " "

case "$USER_TYPE" in

    ONEUI)

        ui_print "✓ User Type: OneUI User"
        ;;

    NONONEUI)

        ui_print "✓ User Type: Non OneUI User"
        ;;

esac

if [ "$SPOOF_DONE" -eq 1 ]; then
    ui_print "✓ Spoofer: $SPOOF_SELECTED"
fi

if [ "$BLUR_DONE" -eq 1 ]; then
    ui_print "✓ Live Blur: $BLUR_SELECTED"
fi

if [ "$AI_DONE" -eq 1 ]; then
    ui_print "✓ Native AI: $AI_SELECTED"
fi

if [ "$FONT_DONE" -eq 1 ]; then
    ui_print "✓ Font: $FONT_SELECTED"
fi

ui_print " "
ui_print "Changes saved successfully."
ui_print " "
ui_print "Module by @Xv2Ice"
ui_print " "
ui_print "Join @bettercallice"
ui_print " "