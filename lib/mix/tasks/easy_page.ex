defmodule Mix.Tasks.EasyPage do
  use Mix.Task

  @moduledoc """
  Generates full featured pages, based on the configuration and templates provided.

  ## Usage
  ```bash
  > mix easy_page.new index="login" Index="Login"
  Scaffolding 'new' with index="login" Index="Login"
  Created file "lib/app_web/pages/login/login.ex"
  Created file "lib/app_web/pages/login/mount.ex"
  Created file "lib/app_web/pages/login/handlers.ex"
  Created file "test/app_web/pages/login/login_test.exs"

  You still need to manually add this page to your router, if not done already.
  ```

  """
  @logo ~s"""
  ███████╗░█████╗░░██████╗██╗░░░██╗  ██████╗░░█████╗░░██████╗░███████╗
  ██╔════╝██╔══██╗██╔════╝╚██╗░██╔╝  ██╔══██╗██╔══██╗██╔════╝░██╔════╝
  █████╗░░███████║╚█████╗░░╚████╔╝░  ██████╔╝███████║██║░░██╗░█████╗░░
  ██╔══╝░░██╔══██║░╚═══██╗░░╚██╔╝░░  ██╔═══╝░██╔══██║██║░░╚██╗██╔══╝░░
  ███████╗██║░░██║██████╔╝░░░██║░░░  ██║░░░░░██║░░██║╚██████╔╝███████╗
  ╚══════╝╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░  ╚═╝░░░░░╚═╝░░╚═╝░╚═════╝░╚══════╝
  """

  def run(cli_opts) do
    opts = get_opts(cli_opts)
    IO.puts(@logo)

    config = Application.fetch_env!(:easy_page, :scaffolds)
    scaffold_name = get_scaffold_name(config)
    scaffold = Keyword.get(config, scaffold_name)
    IO.puts("Great, let's scaffold '#{scaffold_name}'!")

    replacements = get_replacements(Keyword.get(scaffold, :replacements), [])
    paths = get_paths(scaffold, replacements)

    for {from_path, to_path} <- paths do
      safe_write(from_path, to_path, replacements, opts)
    end
  end

  defp safe_write(from_path, to_path, replacements, %{delete_existing_files: true}) do
    body =
      File.read!(from_path)
      |> replace_all(replacements)

    if File.exists?(to_path) do
      File.write!(to_path, body)
      IO.puts("Replaced file #{to_path}")
    else
      File.write!(to_path, body)
      IO.puts("Created file #{to_path}")
    end
  end

  defp safe_write(from_path, to_path, replacements, opts) do
    if File.exists?(to_path) do
      IO.puts("Skipping existing file #{to_path}")
    else
      safe_write(from_path, to_path, replacements, Map.put(opts, :delete_existing_files, true))
    end
  end

  defp get_opts(cli_opts) do
    %{
      delete_existing_files: !!Enum.member?(cli_opts, "-d")
    }
  end

  defp get_paths(scaffold, replacements) do
    paths =
      scaffold
      |> Keyword.get(:paths)
      |> Enum.map(fn {from, to} -> {from, replace_all(to, replacements)} end)

    for {_, to_path} <- paths do
      Path.dirname(to_path)
      |> File.mkdir_p()
    end

    paths
  end

  defp replace_all(str, kwli) do
    Enum.reduce(kwli, str, fn {from, to}, acc ->
      String.replace(acc, from, to)
    end)
  end

  defp get_replacements([], answers), do: answers

  defp get_replacements([hd | tl], answers) do
    answer =
      IO.gets("How would you like to replace the text '#{hd}': ")
      |> String.trim()

    get_replacements(tl, [{hd, answer} | answers])
  end

  defp get_scaffold_name(config) do
    names =
      Keyword.keys(config)
      |> Enum.with_index(1)

    expected_answers = Enum.map(names, fn {_, i} -> "#{i}" end)

    prompt =
      Enum.reduce(names, "Which scaffold would you like to use?\n\n", fn {n, i}, prompt ->
        prompt <> "#{i}] #{n}\n"
      end)

    IO.puts(prompt)
    answer = IO.gets("> ") |> String.trim()

    if answer in expected_answers do
      idx = String.to_integer(answer) - 1
      {k, _idx} = Enum.at(names, idx)
      k
    else
      get_scaffold_name(config)
    end
  end
end
