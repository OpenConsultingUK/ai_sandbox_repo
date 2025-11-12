import os
from google.adk.agents import Agent
# --- IMPORT THE ONLY TOOL WE NEED ---
from google.adk.tools import google_search
# --- IMPORT THE RUNTIME TO START THE AGENT ---
#from google.adk.runtime import run_agent

#
# The google_search tool will automatically load its keys (GOOGLE_CSE_ID
# and GOOGLE_SEARCH_API_KEY) from the .env file.
root_agent = Agent(
    name="fact_agent", 
    model="gemini-2.0-flash", 
    description=(
        "A general-purpose agent that can answer any question."
    ),
    instruction=(
        "You are a helpful and friendly agent. "
        "You MUST use the google_search tool to find the answer to all user questions. "
        "Provide a clear and concise answer based on the search results."
    ),
    # --- THIS IS THE ONLY TOOL IT HAS ---
    tools=[google_search],
)
# --- THIS BLOCK STARTS THE AGENT'S MAIN LOOP ---
# This is a "blocking" call that will run forever
# and keep your container alive.
# if __name__ == "__main__":
#     run_agent(root_agent)