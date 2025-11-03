#!/usr/bin/env python3
# SpeedOS - First Boot Setup
# Executado apenas uma vez após a instalação para configurar o usuário, senha, idioma, etc.

import gi
import os
import sys
import subprocess

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, Adw, GLib

# Marcador para garantir que o script só rode uma vez
MARKER_FILE = "/var/lib/speedos/first_boot_done"

class FirstBootWindow(Adw.ApplicationWindow):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.set_title("Configuração Inicial do SpeedOS")
        self.set_default_size(600, 400)
        self.set_modal(True)
        self.set_resizable(False)

        # Stack para as páginas de configuração
        self.stack = Gtk.Stack.new()
        self.stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)

        # Header Bar
        header = Gtk.HeaderBar.new()
        self.set_titlebar(header)

        # Conteúdo principal
        self.content = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0)
        self.content.append(self.stack)
        self.set_content(self.content)

        # Páginas
        self.create_welcome_page()
        self.create_user_page()
        self.create_language_page()
        self.create_finish_page()

        self.current_page = 0
        self.pages = ["welcome", "user", "language", "finish"]
        self.next_button = Gtk.Button.new_with_label("Próximo")
        self.next_button.connect("clicked", self.on_next_clicked)
        header.pack_end(self.next_button)

        self.stack.set_visible_child_name(self.pages[0])

    def create_welcome_page(self):
        page = Gtk.Box.new(Gtk.Orientation.VERTICAL, 20)
        page.set_margin_all(40)
        
        title = Gtk.Label.new("Bem-vindo ao SpeedOS!")
        title.add_css_class("title-1")
        page.append(title)

        info = Gtk.Label.new("Vamos configurar seu novo sistema operacional para garantir a melhor experiência de velocidade e segurança.")
        info.set_wrap(True)
        page.append(info)

        self.stack.add_titled(page, "welcome", "Bem-vindo")

    def create_user_page(self):
        page = Gtk.Box.new(Gtk.Orientation.VERTICAL, 20)
        page.set_margin_all(40)
        
        title = Gtk.Label.new("Usuário e Senha")
        title.add_css_class("title-1")
        page.append(title)

        # Nome de Usuário
        user_box = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 10)
        user_label = Gtk.Label.new("Nome de Usuário:")
        self.user_entry = Gtk.Entry.new()
        self.user_entry.set_placeholder_text("llucs")
        user_box.append(user_label)
        user_box.append(self.user_entry)
        page.append(user_box)

        # Senha
        pass_box = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 10)
        pass_label = Gtk.Label.new("Senha:")
        self.pass_entry = Gtk.Entry.new()
        self.pass_entry.set_visibility(False)
        pass_box.append(pass_label)
        pass_box.append(self.pass_entry)
        page.append(pass_box)

        self.stack.add_titled(page, "user", "Usuário")

    def create_language_page(self):
        page = Gtk.Box.new(Gtk.Orientation.VERTICAL, 20)
        page.set_margin_all(40)
        
        title = Gtk.Label.new("Idioma e Região")
        title.add_css_class("title-1")
        page.append(title)

        # Idioma
        lang_box = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 10)
        lang_label = Gtk.Label.new("Idioma:")
        self.lang_combo = Gtk.ComboBoxText.new()
        self.lang_combo.append_text("Português (Brasil)")
        self.lang_combo.append_text("English (US)")
        self.lang_combo.set_active(0)
        lang_box.append(lang_label)
        lang_box.append(self.lang_combo)
        page.append(lang_box)

        # Região (Timezone)
        region_box = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 10)
        region_label = Gtk.Label.new("Região (Timezone):")
        self.region_combo = Gtk.ComboBoxText.new()
        self.region_combo.append_text("America/Sao_Paulo")
        self.region_combo.append_text("America/New_York")
        self.region_combo.set_active(0)
        region_box.append(region_label)
        region_box.append(self.region_combo)
        page.append(region_box)

        self.stack.add_titled(page, "language", "Idioma")

    def create_finish_page(self):
        page = Gtk.Box.new(Gtk.Orientation.VERTICAL, 20)
        page.set_margin_all(40)
        
        title = Gtk.Label.new("Configuração Concluída!")
        title.add_css_class("title-1")
        page.append(title)

        info = Gtk.Label.new("O SpeedOS está pronto para uso. Clique em 'Finalizar' para iniciar a sessão.")
        info.set_wrap(True)
        page.append(info)

        self.stack.add_titled(page, "finish", "Finalizar")

    def on_next_clicked(self, button):
        if self.current_page < len(self.pages) - 1:
            self.current_page += 1
            self.stack.set_visible_child_name(self.pages[self.current_page])
            
            if self.current_page == len(self.pages) - 1:
                self.next_button.set_label("Finalizar")
        else:
            self.apply_settings()
            self.close()

    def apply_settings(self):
        # Esta é a parte crítica. No ambiente real, isso usaria ferramentas de sistema (usermod, passwd, localectl)
        # Como estamos em um ambiente de build/simulação, apenas simulamos a execução.
        
        username = self.user_entry.get_text() or "llucs"
        password = self.pass_entry.get_text() or "speedos" # Senha temporária para simulação
        lang = self.lang_combo.get_active_text()
        region = self.region_combo.get_active_text()

        print(f"Aplicando configurações:")
        print(f"Usuário: {username}, Senha: {password}, Idioma: {lang}, Região: {region}")

        # Simulação de comandos de sistema (executados com privilégios de root no ambiente real)
        # subprocess.run(["useradd", "-m", "-s", "/bin/bash", username], check=True)
        # subprocess.run(["chpasswd"], input=f"{username}:{password}".encode(), check=True)
        # subprocess.run(["localectl", "set-locale", f"LANG={lang}"], check=True)
        # subprocess.run(["timedatectl", "set-timezone", region], check=True)

        # Cria o arquivo marcador para não rodar novamente
        os.makedirs(os.path.dirname(MARKER_FILE), exist_ok=True)
        with open(MARKER_FILE, "w") as f:
            f.write("done")

class FirstBootApp(Adw.Application):
    def __init__(self, **kwargs):
        super().__init__(application_id="com.speedos.FirstBoot", **kwargs)
        self.window = None

    def do_activate(self):
        # Verifica se o setup já foi feito
        if os.path.exists(MARKER_FILE):
            print("Configuração inicial já concluída. Encerrando.")
            sys.exit(0)
            
        if not self.window:
            self.window = FirstBootWindow(application=self)
        self.window.present()

if __name__ == "__main__":
    # O script de primeiro boot deve ser executado com privilégios de root para configurar o sistema
    # Mas a interface GTK deve ser executada como o usuário 'live' ou 'default'
    # No ambiente real, o LightDM seria configurado para rodar este script antes do login
    
    # Para simulação, rodamos como usuário normal
    app = FirstBootApp()
    sys.exit(app.run(None))
