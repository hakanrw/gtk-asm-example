#include <gtk/gtk.h>

int show_message(const char* title, const char* message) {
    GtkWidget *dialog;
    GtkWidget *window;

    gtk_init(NULL, NULL);

    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "Message");

    dialog = gtk_message_dialog_new(
        GTK_WINDOW(window),
        GTK_DIALOG_DESTROY_WITH_PARENT,
        GTK_MESSAGE_INFO,
        GTK_BUTTONS_NONE,
        "%s", message
    );

    gtk_dialog_add_buttons(GTK_DIALOG(dialog), "Abort", 3, "Retry", 4, "Ignore", 5, NULL);
    gtk_window_set_title(GTK_WINDOW(dialog), title);
    gtk_widget_set_size_request(dialog, 300, -1);

    int response = gtk_dialog_run(GTK_DIALOG(dialog));
    gtk_widget_destroy(dialog);
    gtk_widget_destroy(window);

    return response;
}
