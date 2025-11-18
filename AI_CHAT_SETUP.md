# AI Chat Setup Guide

## Overview

The AI Chat feature allows users to ask natural language questions about the database and get instant answers. It uses OpenAI to understand questions and Supabase to query the database.

## Setup Instructions

### Step 1: Get OpenAI API Key

1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign up or log in
3. Navigate to [API Keys](https://platform.openai.com/api-keys)
4. Click "Create new secret key"
5. Copy the API key (starts with `sk-`)

### Step 2: Add API Key to Environment Variables

1. Open your `.env.local` file (create it if it doesn't exist)
2. Add your OpenAI API key:

```env
OPENAI_API_KEY=sk-your-actual-api-key-here
```

3. Save the file
4. **Restart your Next.js dev server** for the changes to take effect

### Step 3: Test the Chat

1. Navigate to `/chat` in your application
2. Try asking: "I am david brown, can you tell me my registration date?"
3. The AI should respond with the registration date

## How It Works

1. **User asks a question** in natural language
2. **OpenAI processes** the question and converts it to SQL
3. **Supabase executes** the SQL query safely (only SELECT statements)
4. **Response is formatted** into a single-line answer
5. **User sees** the answer in the chat interface

## Example Questions

- "I am david brown, can you tell me my registration date?"
- "What is my total spending?"
- "How many orders do I have?"
- "Show me all my orders"
- "What is my email address?"
- "I am jane smith, what is my total spent?"

## Security Features

- ✅ Only SELECT queries are allowed
- ✅ Dangerous SQL keywords are blocked (DROP, DELETE, UPDATE, etc.)
- ✅ Queries are validated before execution
- ✅ Uses Supabase admin client for secure queries

## Troubleshooting

### "OpenAI API key not configured"

- Make sure `.env.local` exists
- Verify `OPENAI_API_KEY` is set correctly
- Restart the dev server after adding the key

### "I couldn't understand your question"

- Try rephrasing your question
- Be more specific about what you're asking
- Include your name if asking about personal data

### "I couldn't find any matching information"

- Make sure you've run `sql/sample_data.sql` in Supabase
- Verify the customer name matches exactly (case-insensitive)
- Check that RLS is disabled or public read is enabled

## API Endpoint

The chat API is available at `/api/chat` and accepts POST requests:

```json
{
  "message": "I am david brown, can you tell me my registration date?",
  "customerName": "David Brown" // optional
}
```

Response:
```json
{
  "answer": "Your registration date is April 5, 2023.",
  "sql": "SELECT registration_date FROM customers WHERE LOWER(first_name) = 'david' AND LOWER(last_name) = 'brown'",
  "data": [...]
}
```

## Cost Considerations

- OpenAI API usage is charged per request
- Using `gpt-4o-mini` model is cost-effective
- Each chat message uses approximately 200-500 tokens
- Monitor your usage at [OpenAI Usage Dashboard](https://platform.openai.com/usage)

## Customization

You can customize the AI's behavior by editing `app/api/chat/route.ts`:
- Change the system prompt
- Modify the model (gpt-4o-mini, gpt-4, etc.)
- Adjust temperature for more/less creative responses
- Add support for more query types


