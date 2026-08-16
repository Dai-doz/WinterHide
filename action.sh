#!/system/bin/sh

# =========================================================
# Winter Hide
# Action / Status Viewer
#
# by Xv2Ice
# Thanks MRX7014 for using his own S26U Spoofer
# =========================================================

# =========================================================
# Module Directory
# =========================================================

MODDIR="${0%/*}"

# =========================================================
# KSU / Magisk Compatibility Helper
# =========================================================

ui_print() {
    echo "$1"
}

# =========================================================
# Helpers
# =========================================================

read_state() {
    FILE="$1"
    DEFAULT="$2"

    if [ -f "$MODDIR/$FILE" ]; then
        VALUE="$(cat "$MODDIR/$FILE" 2>/dev/null)"
        if [ -n "$VALUE" ]; then
            printf '%s' "$VALUE"
            return 0
        fi
    fi

    printf '%s' "$DEFAULT"
}

# =========================================================
# Count Valid Spoofers
# =========================================================

count_spoofers() {
    DIR="$1"
    COUNT=0

    if [ ! -d "$DIR" ]; then
        printf '0'
        return 0
    fi

    for ITEM in "$DIR"/*; do
        [ -d "$ITEM" ] || continue
        if [ -f "$ITEM/system.prop" ]; then
            COUNT=$((COUNT + 1))
        fi
    done

    printf '%s' "$COUNT"
}

# =========================================================
# Count Valid Fonts
# =========================================================

count_fonts() {
    COUNT=0

    if [ ! -d "$MODDIR/Fonts" ]; then
        printf '0'
        return 0
    fi

    for ITEM in "$MODDIR/Fonts"/*; do
        [ -d "$ITEM" ] || continue
        if [ -f "$ITEM/Roboto-Regular.ttf" ]; then
            COUNT=$((COUNT + 1))
        fi
    done

    printf '%s' "$COUNT"
}

# =========================================================
# Load Saved Configuration
# =========================================================

USER_TYPE="$(read_state "user_type" "UNKNOWN")"
SPOOFER="$(read_state "spoofer_name" "Not selected")"
FONT="$(read_state "font_name" "Not selected")"

BLUR="$(read_state "blur_state" "Not configured")"
AI="$(read_state "ai_state" "Not configured")"

# =========================================================
# Resolve Profile
# =========================================================

case "$USER_TYPE" in
    ONEUI)
        PROFILE_NAME="OneUI User"
        ACTIVE_SPOOFER_DIR="$MODDIR/SpoofersOneUI"
        ACTIVE_SPOOFER_NAME="SpoofersOneUI"
        ;;
    NONONEUI)
        PROFILE_NAME="Non OneUI User"
        ACTIVE_SPOOFER_DIR="$MODDIR/SpoofersNonOneUI"
        ACTIVE_SPOOFER_NAME="SpoofersNonOneUI"
        ;;
    *)
        PROFILE_NAME="Unknown"
        ACTIVE_SPOOFER_DIR=""
        ACTIVE_SPOOFER_NAME="Unknown"
        ;;
esac

# =========================================================
# Dynamic Detection
# =========================================================

ONEUI_SPOOFER_COUNT="$(count_spoofers "$MODDIR/SpoofersOneUI")"
NONONEUI_SPOOFER_COUNT="$(count_spoofers "$MODDIR/SpoofersNonOneUI")"
FONT_COUNT="$(count_fonts)"

# =========================================================
# Header
# =========================================================

ui_print " "
ui_print "========================================"
ui_print "             WINTER HIDE"
ui_print "            MODULE STATUS"
ui_print "========================================"
ui_print " "

# =========================================================
# USER PROFILE
# =========================================================

ui_print "USER PROFILE"
ui_print "----------------------------------------"

case "$USER_TYPE" in
    ONEUI)
        ui_print "User Type : OneUI User"
        ;;
    NONONEUI)
        ui_print "User Type : Non OneUI User"
        ;;
    *)
        ui_print "User Type : Unknown"
        ;;
esac

ui_print " "

# =========================================================
# SPOOFER
# =========================================================

ui_print "SPOOFER"
ui_print "----------------------------------------"

if [ "$SPOOFER" = "Not selected" ]; then
    ui_print "Status    : Not selected"
else
    ui_print "Status    : Applied"
    ui_print "Selected  : $SPOOFER"
    ui_print "Source    : $ACTIVE_SPOOFER_NAME/$SPOOFER"
fi

ui_print " "

# =========================================================
# FONT
# =========================================================

ui_print "FONT"
ui_print "----------------------------------------"

if [ "$FONT" = "Not selected" ]; then
    ui_print "Status    : Not selected"
else
    ui_print "Status    : Applied"
    ui_print "Pack      : $FONT"

    if [ -f "$MODDIR/system/fonts/Roboto-Regular.ttf" ]; then
        ui_print "Roboto    : Installed"
    else
        ui_print "Roboto    : Missing"
    fi

    if [ -f "$MODDIR/system/fonts/NotoColorEmoji.ttf" ]; then
        ui_print "Emoji     : Installed"
    else
        ui_print "Emoji     : Not included"
    fi

    if [ "$USER_TYPE" = "ONEUI" ]; then
        if [ -f "$MODDIR/system/fonts/OneUISans-VF.ttf" ]; then
            ui_print "OneUI Sans: Installed"
        else
            ui_print "OneUI Sans: Not included"
        fi
    fi
fi

ui_print " "

# =========================================================
# LIVE BLUR
# =========================================================

if [ "$USER_TYPE" = "ONEUI" ]; then
    ui_print "LIVE BLUR"
    ui_print "----------------------------------------"

    case "$BLUR" in
        Enable)
            ui_print "Status    : Enabled"
            ;;
        Disable)
            ui_print "Status    : Disabled"
            ;;
        "Keep As Base")
            ui_print "Status    : Keep As Base"
            ;;
        *)
            ui_print "Status    : Not configured"
            ;;
    esac

    ui_print " "
fi

# =========================================================
# NATIVE AI
# =========================================================

if [ "$USER_TYPE" = "ONEUI" ]; then
    ui_print "NATIVE AI"
    ui_print "----------------------------------------"

    case "$AI" in
        Enable)
            ui_print "Status    : Enabled"
            ;;
        Disable)
            ui_print "Status    : Disabled"
            ;;
        "Keep As Base")
            ui_print "Status    : Keep As Base"
            ;;
        *)
            ui_print "Status    : Not configured"
            ;;
    esac

    ui_print " "
fi

# =========================================================
# AVAILABLE CONTENT
# =========================================================

ui_print "AVAILABLE CONTENT"
ui_print "----------------------------------------"

ui_print "OneUI Spoofers     : $ONEUI_SPOOFER_COUNT"
ui_print "Non-OneUI Spoofers : $NONONEUI_SPOOFER_COUNT"
ui_print "Font Packs         : $FONT_COUNT"

ui_print " "

# =========================================================
# ACTIVE SOURCE
# =========================================================

ui_print "ACTIVE SOURCE"
ui_print "----------------------------------------"

case "$USER_TYPE" in
    ONEUI)
        ui_print "SpoofersOneUI/"
        ;;
    NONONEUI)
        ui_print "SpoofersNonOneUI/"
        ;;
    *)
        ui_print "No active source."
        ;;
esac

ui_print " "

# =========================================================
# CONFIGURATION STATUS
# =========================================================

ui_print "CONFIGURATION"
ui_print "----------------------------------------"

if [ "$SPOOFER" != "Not selected" ]; then
    ui_print "✓ Spoofer configured"
else
    ui_print "✗ Spoofer not configured"
fi

if [ "$FONT" != "Not selected" ]; then
    ui_print "✓ Font configured"
else
    ui_print "✗ Font not configured"
fi

if [ "$USER_TYPE" = "ONEUI" ]; then
    case "$BLUR" in
        Enable|Disable|"Keep As Base")
            ui_print "✓ Live Blur configured"
            ;;
        *)
            ui_print "✗ Live Blur not configured"
            ;;
    esac

    case "$AI" in
        Enable|Disable|"Keep As Base")
            ui_print "✓ Native AI configured"
            ;;
        *)
            ui_print "✗ Native AI not configured"
            ;;
    esac
fi

ui_print " "

# =========================================================
# FINAL SUMMARY
# =========================================================

ui_print "========================================"
ui_print "          WINTER HIDE SUMMARY"
ui_print "========================================"
ui_print " "

ui_print "Profile : $PROFILE_NAME"

if [ "$SPOOFER" != "Not selected" ]; then
    ui_print "Spoofer : $SPOOFER"
fi

if [ "$FONT" != "Not selected" ]; then
    ui_print "Font    : $FONT"
fi

if [ "$USER_TYPE" = "ONEUI" ]; then
    ui_print "Blur    : $BLUR"
    ui_print "AI      : $AI"
fi

ui_print " "

ui_print "========================================"
ui_print "       WINTER HIDE STATUS COMPLETE"
ui_print "========================================"
ui_print " "
ui_print "Module by @Xv2Ice"
ui_print " "
ui_print "Join @bettercallice"
ui_print " "