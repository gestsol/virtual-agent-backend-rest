defmodule ChatbotWeb.LogControllerTest do
  use ChatbotWeb.ConnCase

  alias Chatbot.Others
  alias Chatbot.Others.Log

  @create_attrs %{
    finalised_chats: 42,
    selected_option: 42,
    selected_question: 42,
    tier: 42,
    unfinalised_chats: 42
  }
  @update_attrs %{
    finalised_chats: 43,
    selected_option: 43,
    selected_question: 43,
    tier: 43,
    unfinalised_chats: 43
  }
  @invalid_attrs %{finalised_chats: nil, selected_option: nil, selected_question: nil, tier: nil, unfinalised_chats: nil}

  def fixture(:log) do
    {:ok, log} = Others.create_log(@create_attrs)
    log
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all logs", %{conn: conn} do
      conn = get(conn, Routes.log_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create log" do
    test "renders log when data is valid", %{conn: conn} do
      conn = post(conn, Routes.log_path(conn, :create), log: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.log_path(conn, :show, id))

      assert %{
               "id" => id,
               "finalised_chats" => 42,
               "selected_option" => 42,
               "selected_question" => 42,
               "tier" => 42,
               "unfinalised_chats" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.log_path(conn, :create), log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update log" do
    setup [:create_log]

    test "renders log when data is valid", %{conn: conn, log: %Log{id: id} = log} do
      conn = put(conn, Routes.log_path(conn, :update, log), log: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.log_path(conn, :show, id))

      assert %{
               "id" => id,
               "finalised_chats" => 43,
               "selected_option" => 43,
               "selected_question" => 43,
               "tier" => 43,
               "unfinalised_chats" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, log: log} do
      conn = put(conn, Routes.log_path(conn, :update, log), log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete log" do
    setup [:create_log]

    test "deletes chosen log", %{conn: conn, log: log} do
      conn = delete(conn, Routes.log_path(conn, :delete, log))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.log_path(conn, :show, log))
      end
    end
  end

  defp create_log(_) do
    log = fixture(:log)
    {:ok, log: log}
  end
end
